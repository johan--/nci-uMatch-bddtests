var AWS = require ('aws-sdk');

var DynamoHelper = function() {
    var DynamoDB = new AWS.DynamoDB({
        region: 'us-east-1',
        endpoint: process.env.DYNAMO_ENDPOINT, 
        accessKeyId: process.env.AWS_ACCESS_KEY_ID, 
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, 
        apiVersion: 'latest'
    });

    this.checkForRecord = function(record, table){
        var params = {
            ExpressionAttributeValues: {
                ":record": {
                    S: record
                }
            }, 
            KeyConditionExpression: "treatment_arm_id = :record", 
            ProjectionExpression: "treatment_arm_id", 
            TableName: table
        };

        var getRecords = DynamoDB.query(params).promise();
        return getRecords.then(function (data){
            return data;
        }).catch(function(err){
            console.log(err);
            return;
        });
    }
};

module.exports = new DynamoHelper();
