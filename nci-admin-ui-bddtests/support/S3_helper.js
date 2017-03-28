var AWS = require ('aws-sdk');

var S3_helper = function () {
    var S3 = new AWS.S3({
        region: 'us-east-1',
        endpoint: 'https://s3.amazonaws.com', 
        accessKeyId: process.env.AWS_ACCESS_KEY_ID, 
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, 
        apiVersion: 'latest'
    });

    this.isFilePresent = function(bucketName, fileName) {
        
        var params = {
            Bucket: bucketName,
            EncodingType: 'url',
            MaxKeys: 1000
        }

        var listPromise = S3.listObjects(params).promise();
        return listPromise.then(function(data){
            var contents = data.Contents;
            flag = 0
            for (var i = 0; i < data.Contents.length; i++) {
                if (data.Contents[i].Key.includes(fileName)) {
                        flag = 1;
                        return contents[i];
                } 
            }
            if (flag === 0){
                return false;
            }
        }).catch(function(err){
            console.log(err);
            return;
        });
    };

    this.deleteFileFromBucket = function(bucketName, fileName) {
        var params = {
            Bucket: bucketName, 
            Key: fileName, 
            MFA: 'STRING_VALUE',
            RequestPayer: 'requester',
            VersionId: 'STRING_VALUE'
        };
        var deletePromise = S3.deleteObject(params).promise();
        return deletePromise.then(function(data){
            console.log("Deleted file:" + fileName);
            return;
        }).catch(function(err){
            console.log(err);
            return;
        });
    }

}

module.exports = new S3_helper();