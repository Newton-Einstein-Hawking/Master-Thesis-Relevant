import sys
# sys.path.append('D:\\Sync\Codes\AOM Driver\py_tof_sequence')
# sys.path.append('D:\\Sync\Codes\ToF')
sys.path.append('C:\\Users\AMO lab\Documents\Codes\Rydberg')
import PySpin
import os
os.environ["KMP_DUPLICATE_LIB_OK"] = "True"
import FLIRTriggerQuickSpin_YZ as ftqs
from TTL_new import TTL,ms,us,ns
import numpy as np
import matplotlib.pyplot as plt
import cv2
import time
import pandas as pd
from scipy.optimize import curve_fit
#### This program is design to measure the temperature of MOT ####

## Time list
t_MOT = 400 * ms
t_meas = 22 * ms
t_compress = 60*ms
t_PGC = 4*ms
t_mag_off = 2*ms # 0

## Amp list
I_trap = 0.10
I_repump = 0.10
## MOT coil current
V = 1.56 #1.65
V_compress = 1.56 # 2.15

## Status list
CMOT_status = True
PGC_status = True # False

T = t_MOT + t_compress * CMOT_status + t_PGC * PGC_status + t_meas # 210*ms # Period of one cycle

## Detection
t_cam = t_MOT + t_compress * CMOT_status + t_PGC * PGC_status + 5*ms
t_flou = t_cam + 50*us 
t_flou_duration = 100*us 

test = TTL(T)

start_t = np.arange(0,20,1)*0.5e-3 # time to be measured
duration = 100e-6 # measure time 
delay = 0 # 500e-6 # measure after start_t
# trigger_delay = 50e-6 # open trigger in advance,the trigger delay must be smaller than the delay+first start_time, otherwise there will be flourescence
num = 10 # picture capertured for each t

# foldername = 'Tof_CCMOT_op2_' + '%.2f'%I_trap + '_' + '%.2f'%I_repump + '_' + '%d'%(t_coolMOT*1e3) + 'ms_' + '%.2f'%V_compress +'V'
foldername = 'Tof_CCMOT_' + '%.2f'%I_trap + '_' + '%.2f'%I_repump + '_' + '%d'%(t_compress*1e3) + 'ms_' + '%.2f'%V_compress +'V'

print(foldername)
filepath = 'C:\\Users\AMO lab\Documents\Rydberg Data\\2023\\11\\29\\'+foldername # if empty, donot save, otherwise save the average photon with removed background
if filepath != '' and os.path.exists(filepath) == False:
    os.makedirs(filepath)

affix = 'ToF_'
# ROI setting 384,400,720,240/384,400,720,300 /288,300,952,540 / 192,200,1000,640 /192,200,975,640

# Time sequence initialization, no repump, get the background
test = TTL(T)

# MOT
test.add_DDS(1,[0,t_MOT],72*np.ones(2),[0.25,0.25])
test.add_DDS(2,[0,t_MOT],63*np.ones(2),[0.25,0.25]) 
test.add_DAC(1,[0,t_MOT],[V,V])

# CMOT
if CMOT_status == True:
    test.append_DDS(1,np.linspace(t_MOT,t_MOT+t_compress/2,50),72*np.ones(50),np.linspace(0.25,I_trap,50))
    test.append_DDS(1,[t_MOT+t_compress/2,t_MOT+t_compress],[72,72],[I_trap,I_trap])
    if PGC_status == True:
        test.append_DDS(2,np.linspace(t_MOT,t_MOT+t_compress ,50),63*np.ones(50),np.concatenate((np.linspace(0.20,I_repump,10),np.linspace(I_repump,I_repump,38),[0.,0.])))  
    else:
        test.append_DDS(2,np.linspace(t_MOT,t_MOT+t_compress-1*ms,50),63*np.ones(50),np.linspace(0.20,0.06,50))   
    test.append_DAC(1,[t_MOT,t_MOT+t_compress],[V,V])

t_now = t_MOT + t_compress * CMOT_status

# PGC
if PGC_status == True:
    test.append_DDS(1,np.linspace(t_now, t_now + t_PGC,50),np.linspace(72,62,50),np.linspace(0.1,0.1,50))
    test.append_DDS(2,np.linspace(t_now, t_now + t_PGC,50),63*np.ones(50),np.concatenate((np.linspace(0.06,0,48),[0,0])))
    test.append_DAC(1,[t_now,t_now + t_PGC],[V,V])

t_now = t_now + t_PGC * PGC_status

test.add_delay('MOT coil',5,True,0, t_MOT + t_compress*CMOT_status -t_mag_off)
test.add_delay('monit', 1,True, t_cam, T)

## Detection by flourescence:

test.append_DDS(1,[t_flou, t_flou + t_flou_duration, T],[72,72,72],[0,0.25,0.])
test.append_DDS(2,[t_flou, t_flou + t_flou_duration, T],[63,63,63],[0,0.,0.])
# test.append_DDS(2,[t_flou, t_flou + t_flou_duration, T],[63,63,63],[0,0.20,0.])
test.add_delay('camera trigger 1', 4,True, t_cam, T)
test.add_delay('camera trigger 2', 9,True, t_cam, T)

test.run_TTL()

# Camera initialization
result = True
# Retrieve singleton reference to system object
system = PySpin.System.GetInstance()
# Retrieve list of cameras from the system
cam_list = system.GetCameras()
num_cameras = cam_list.GetSize()
print('Number of cameras detected: %d' % num_cameras)
cam = cam_list[0]
print('Running camera ...')
# Initialize camera
cam.Init()
# Retrieve GenICam nodemap
nodemap = cam.GetNodeMap()
# Configure trigger
ftqs.configure_trigger(cam)

## Background recorded
temp = ftqs.acquire_images_return(cam,num, '')
# print(temp)

result_temp,bg = temp
result = result & result_temp

bg_ave = bg.mean(axis = 2)
cv2.imwrite(filepath +'/'+ affix +'bg.png',bg_ave)

a,b = bg_ave.shape
data_all = np.zeros((a,b,len(start_t)))
i = 0
# Take data with different time

l = len(test.DDS[0])
test.DDS[1]['amplitude'][l-2] = 0.20
test.DDS[0]['amplitude'][l-2] = 0.25
for t in start_t:
    t_cam = t_MOT + t_compress * CMOT_status + t_PGC * PGC_status + t
    t_flou = t_cam + 50*us 

    test.DDS[0]['t'][l-3] = t_flou
    test.DDS[1]['t'][l-3] = t_flou
    test.DDS[0]['t'][l-2] = t_flou + t_flou_duration
    test.DDS[1]['t'][l-2] = t_flou + t_flou_duration

    test.modify('camera trigger 1','start_t',t_cam)
    test.modify('camera trigger 2','start_t',t_cam)
    test.run_TTL()

    time.sleep(5)
    result_temp, data = ftqs.acquire_images_return(cam,10, '')
    result = result & result_temp
    data_ave = data.mean(axis = 2)
    data_all[:,:,i] = data_ave - bg_ave
    cv2.imwrite(filepath + '/data_' + affix + str(i) +'.png',data_ave- bg_ave)
    print('Data save to: '+filepath + '/data_' + affix + str(i) +'.png')
    i = i + 1
    

# Close camera    
del cam
# Clear camera list before releasing system
cam_list.Clear()
# Release system instance
system.ReleaseInstance()

t_MOT = 200 * ms
t_meas = 22 * ms
t_compress = 40*ms
t_PGC = 0*ms
t_mag_off = 0*ms
## Save param:
# np.savetxt('params.txt',t_MOT,)

# ## Analyze data
# def gaussian_2d(xy, amplitude, xo, yo, sigma_x, sigma_y):
#     x, y = xy
#     xo = float(xo)
#     yo = float(yo)
#     g = amplitude * np.exp(-( (x - xo)**2 / (2* sigma_x**2) +  (y - yo)**2 /(2* sigma_y**2)))
#     return g.ravel()


# ny,nx,n = data_all.shape
# x = np.arange(0, nx)
# y = np.arange(0, ny)
# X, Y = np.meshgrid(x, y)
# # 初始拟合参数
# fit_res = np.zeros((n,5))

# plt.figure(1)

# def gaussian(x, amplitude, xo, sigma):
#     xo = float(xo)
#     g = amplitude * np.exp(-( (x - xo)**2 / (2* sigma**2) ))
#     return g

# start_t = np.arange(0,10,1)*0.5e-3 # time to be measured
# duration = 100e-6 # measure time 
# delay = 500e-6 # measure after start_t

# ny,nx,n = data_all.shape
# x = np.arange(0, nx)
# y = np.arange(0, ny)
# X, Y = np.meshgrid(x, y)
# # 初始拟合参数
# fit_res = np.zeros((n,5))

# plt.figure(1,figsize = [15,6])

# for i in range(len(start_t)):
# # 读取灰度值二维数组
#     image = data_all[:,:,i] - bg_ave

#     initial_guess1 = (np.max(image.mean(axis = 0)), 166, 2)
#     initial_guess2 = (np.max(image.mean(axis = 1)), 139, 2)
#     # 执行拟合
#     popt1, pcov1 = curve_fit(gaussian, x[100:-1], image.mean(axis = 0)[100:-1], p0=initial_guess1)
#     popt2, pcov2 = curve_fit(gaussian, y[0:200], image.mean(axis = 1)[0:200], p0=initial_guess2)

#     # 提取拟合结果
#     amplitude, xo,  sigma_x = popt1
#     amplitude, yo,  sigma_y = popt2
#     fit_res[i,1] = xo
#     fit_res[i,2] = yo
#     fit_res[i,3] = sigma_x
#     fit_res[i,4] = sigma_y
#     fit_res[i,0] = amplitude
#     print('xo = ', xo, ',yo = ', yo)
#     print('sigma_x = ', sigma_x, 'sigma_y = ', sigma_y)

#     plt.subplot(2,5,i+1)
#     plt.imshow(image, cmap='gray')
#     plt.plot(x, nx-gaussian(x,1,xo,sigma_x)*100)
#     plt.xlim([0,ny])
#     plt.ylim([nx,0])
#     plt.xlabel('x')
#     plt.ylabel('y') 

# plt.show()
# # Save fitting result
# df = pd.Dataframe(fit_res,columns = ['amplitude','x0','y0','sigma_x','sigma_y'])
# df.to_csv(filepath + '/fit_res_' + affix + '.csv',index = True)

# ## Fitting for the temperature
# # Boltzmann’s constant
# k_B = 1.3806504e-23
# # Atomic mass of Rb85
# m = 1.409993199e-25
# # Gravitational aceleration
# g = 9.7803
# # Gaussian radius of cold atom colud
# # sigma_0 = 1.33168672*5.86e-6

# def expansion( t,sigma_0, T):
#     return sigma_0**2+k_B*T*t**2/m

# initial_guess = [10,20e-6]
# popt, pcov = curve_fit(expansion,start_t +delay, fit_res[:,3], p0=initial_guess)
# print('sigma_0 = ',popt[0],'temperature = ',popt[1])

# plt.figure(2)
# plt.subplot(1,2,1)
# plt.plot((start_t+delay)*1e3,(fit_res[:,1] -fit_res[0,1])* 5.86e-3,'o--',label = 'x0')
# plt.plot((start_t+delay)*1e3,(fit_res[:,2] - fit_res[0,2])* 5.86e-3,'o--',label = 'z0')
# plt.plot((start_t+delay)*1e3,0.5*9.8*(start_t+delay)**2 * 1e3,'--',label = r'$\frac{1}{2}gt^2$')
# plt.legend()
# plt.xlabel('Time (ms)')
# plt.ylabel('Position (mm)')

# plt.subplot(1,2,2)
# plt.plot((start_t+delay)*1e3,fit_res[:,3]*5.86e-3,'sigma_x')
# plt.plot((start_t+delay)*1e3,fit_res[:,4]*5.86e-3,'sigma_z')
# plt.plot((start_t+delay)*1e3,expansion(start_t+delay,popt[0],popt[1])*5.86e-3)
# plt.xlabel('Time (ms)')
# plt.ylabel(r'$\sigma$ (mm)')
# plt.show()

