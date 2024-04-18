%% 导入文本文件中的数据。
% 用于从以下文本文件导入数据的脚本:
%
%    D:\OneDrive - 南方科技大学\专利申请书\distortion_and_field_curvature_486nm.txt
%
% 要将代码扩展到其他选定数据或其他文本文件，请生成函数来代替脚本。

% 由 MATLAB 自动生成于 2023/10/13 19:54:13

%% 初始化变量。
filename = 'D:\OneDrive - 南方科技大学\各种书面文件（培养方案里的）\master thesis\figures\microscope objective\场曲和畸变的图（这个比较麻烦，直接运行MAIN_FILE即可）\distortion_and_field_curvature_486nm.txt';

%% 将数据列作为文本读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%16s%16s%16s%16s%16s%15s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值文本的列内容转换为数值。
% 将非数值文本替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6]
    % 将输入元胞数组中的文本转换为数值。已将非数值文本替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 将数值文本转换为数值。
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% 将数据拆分为数值和字符串列。
rawNumericColumns = raw(:, [1,2,3,4,5,6]);
rawStringColumns = string(raw(:, 7));


%% 确保包含 <undefined> 的任何文本都已正确转换为 <undefined> 分类值
idx = (rawStringColumns(:, 1) == "<undefined>");
rawStringColumns(idx, 1) = "";

%% 创建输出变量
distortionandfieldcurvature486nm = table;
distortionandfieldcurvature486nm.VarName1 = cell2mat(rawNumericColumns(:, 1));
distortionandfieldcurvature486nm.VarName2 = cell2mat(rawNumericColumns(:, 2));
distortionandfieldcurvature486nm.VarName3 = cell2mat(rawNumericColumns(:, 3));
distortionandfieldcurvature486nm.VarName4 = cell2mat(rawNumericColumns(:, 4));
distortionandfieldcurvature486nm.VarName5 = cell2mat(rawNumericColumns(:, 5));
distortionandfieldcurvature486nm.VarName6 = cell2mat(rawNumericColumns(:, 6));
distortionandfieldcurvature486nm.VarName7 = categorical(rawStringColumns(:, 1));

%% 清除临时变量
clearvars filename formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns idx;