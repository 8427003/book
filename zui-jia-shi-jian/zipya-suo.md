# Zip 压缩

// 优点，适合web，缺点：不支持本地文件，中文未测试  
const JSZip = require\('jszip'\)

//优点：支持本地文件，缺点：不支持中文，不支持文件通配符  
const AdmZip = require\('adm-zip'\);

// 优点：这个最好，支持通配符，支持本地文件，目录更改，最重要是中文也可以  
const archiver = require\('archiver'\);

