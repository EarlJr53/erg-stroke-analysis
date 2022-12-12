function PublishtoProjectPages(scriptfilename)

opts = struct('format','xml','outputDir','docs/_posts/published','imageFormat','png');
filepath = publish(scriptfilename,opts);

fid = fopen(filepath);
Data = textscan(fid,'%s','Delimiter','\n','Whitespace','');
Data = Data{1};
fclose(fid);

fid = fopen(filepath);
Data2 = textscan(fid,'%s','Delimiter','\n');
Data2 = Data2{1};
fclose(fid);

for i = 1:length(Data)
    currentline = Data{i};
    currentline2 = Data2{i};
    if size(currentline,2) > 0
        if size(currentline2,2) > 0
            if currentline2(1) == '<'
                Data{i}=currentline2;
            end
        end
    end
end

cd docs/_posts/published

fileID = fopen('aligned.xml','w');

for i = 1:length(Data)
    fprintf(fileID,'%s\n',Data{i});
end

fclose(fileID);

xslt('aligned.xml','\..\toprojectpages.xsl','firstpass.md');

fid = fopen('firstpass.md');
Data3 = textscan(fid,'%s','Delimiter','\n','Whitespace','');
Data3 = Data3{1};
fclose(fid);

for i = 1:length(Data3)
    currentline3 = Data3{i};
    if size(currentline3,2) > 5
        if currentline3(1:4) == '<img'
            startIndex = regexp(currentline3,'"');
            imagename=currentline3(startIndex(1)+1:startIndex(2)-1);
            fid = fopen(imagename,'rb');
            bytes = fread(fid);
            fclose(fid);
            encoder = org.apache.commons.codec.binary.Base64;
            base64string = char(encoder.encode(bytes))';
            currentline3 = ['<img src="data:image/png;base64,',base64string,'" />'];
            Data3{i} = currentline3;
        end
    end
end

daterightnow = datevec(datetime('today'));

newfilename = [num2str(daterightnow(1)),'-'];

if daterightnow(2) < 10
    newfilename = [newfilename,'0',num2str(daterightnow(2)),'-'];
else
    newfilename = [newfilename,num2str(daterightnow(2)),'-'];
end

if daterightnow(3) < 10
    newfilename = [newfilename,'0',num2str(daterightnow(3)),'-matlabpost.md'];
else
    newfilename = [newfilename,num2str(daterightnow(3)),'-matlabpost.md'];
end

fileID = fopen(newfilename,'w');

for i = 1:length(Data3)
    fprintf(fileID,'%s\n',Data3{i});
end

fclose(fileID);



