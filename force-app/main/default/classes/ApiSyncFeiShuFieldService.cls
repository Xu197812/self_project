public with sharing class ApiSyncFeiShuFieldService {

    //应用秘钥
    public static String appSecret = 'rvxTcmOryY5f53jR74I87b1aqZPiUv8W';
    //飞书应用的唯一标识
    public static String appId = 'cli_a48d4d60b5fcd00d';
    //多维表格的唯一标识符
    public static String appToken = 'bascnOvN8d1dnQWq0S7cgR7n6jb';
    //多维表格数据表的唯一标识符
    public static String tableId = 'tblhaAhqLU9OJt3r';


  	/**
     * 批处理调用方法，从飞书接口中获取多维表的数据表满足要求的记录
     * 一次500条，如果数据表中数据大于500，请求接口时添加最后修改时间的查询条件
     */
  	public static Map<String, String> getFeiShuRecords(){
        Map<String, String> temp = new Map<String, String>();
        String pageToken = '';

        //请求多维表数据表的查询条件
        String filter = 'NOT%28CurrentValue.%5B%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%5D+%3D%22%22%29%26%26NOT%28CurrentValue.%5B%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%5D+%3D%22%22%29';
        String pageSize = '500';
        String fieldNames = '%5B%22%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%22%2C%22%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%22%5D';
        String url = 'https://open.feishu.cn/open-apis/bitable/v1/apps/' + appToken + '/tables/' + tableId + '/records?page_size=' + pageSize + '&field_names=' + fieldNames + '&automatic_fields=true&filter=' + filter + '&page_token=' + pageToken;

        HttpResponse response = httpRequest(url);

        Map<String, Object> retrunMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> data = retrunMap.get('data') == null? new Map<String, Object>() : (Map<String, Object>) retrunMap.get('data');
        List<Object> items = data.get('items') == null? new List<Object>() : (List<Object>) data.get('items');
        for (Object item : items) {
        	Map<String, Object> itemMap = (Map<String, Object>) item;
        	Map<String, Object> fields = itemMap.get('fields') == null?null:(Map<String, Object>) itemMap.get('fields');
        	temp.put((String) fields.get('商机编码'),(String) fields.get('评审结论'));
        }
        return temp;
    }

    /**
     * 批处理调用方法，从飞书接口中获取多维表的数据表满足要求的记录
     * 一次500条，如果数据表中数据大于500，请求接口时添加最后修改时间的查询条件
     */
    public static Map<String, String> getFeiShuRecordsByLimit(){
        Map<String, String> temp = new Map<String, String>();
        Boolean hasMore = true;
        String pageToken = '';

        while(hasMore){
        //请求多维表数据表的查询条件
            String filter = 'NOT%28CurrentValue.%5B%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%5D+%3D%22%22%29%26%26NOT%28CurrentValue.%5B%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%5D+%3D%22%22%29';
            String pageSize = '500';
            String fieldNames = '%5B%22%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%22%2C%22%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%22%5D';
            String url = 'https://open.feishu.cn/open-apis/bitable/v1/apps/' + appToken + '/tables/' + tableId + '/records?page_size=' + pageSize + '&field_names=' + fieldNames + '&automatic_fields=true&filter=' + filter + '&page_token=' + pageToken;

            HttpResponse response = httpRequest(url);

            Map<String, Object> retrunMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> data = retrunMap.get('data') == null? new Map<String, Object>() : (Map<String, Object>) retrunMap.get('data');
            List<Object> items = data.get('items') == null? new List<Object>() : (List<Object>) data.get('items');

            Datetime nt = Datetime.now();
            Long nowTime = nt.getTime();
            Long beforeTime = nt.getTime() - 1000 * 60 * 60;

            for (Object item : items) {
                Map<String, Object> itemMap = (Map<String, Object>) item;
                Long lastUpdeteTime = itemMap.get('last_modified_time') == null ? null : (Long) itemMap.get('last_modified_time');
                if (lastUpdeteTime > beforeTime && lastUpdeteTime < nowTime) {
                    Map<String, Object> fields = itemMap.get('fields') == null?null:(Map<String, Object>) itemMap.get('fields');
                    if(temp.values().size() < 500){
                        temp.put((String) fields.get('商机编码'),(String) fields.get('评审结论'));
                    }
                }
            }
            pageToken = data.get('page_token') == null ? '': (String) data.get('page_token');
            hasMore = data.get('has_more') == null? false: (Boolean) data.get('has_more');
        }
        return temp;
    }


    /**
     * 流中调用方法，从飞书接口中获取多维表的数据表满足要求的记录
     * 一次1条
     */
    @InvocableMethod
    public static void getRecordById(List<String> parameters){

        Map<String, String> temp = new Map<String, String>();
        String pageToken = '';
        String code = parameters.get(0);

        String filter = 'NOT%28CurrentValue.%5B%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%5D+%3D%22%22%29%26%26NOT%28CurrentValue.%5B%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%5D+%3D%22%22%29%26%26CurrentValue.%5B%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%5D+%3D%22' + code + '%22';
        String pageSize = '1';
        String fieldNames = '%5B%22%E8%AF%84%E5%AE%A1%E7%BB%93%E8%AE%BA%22%2C%22%E5%95%86%E6%9C%BA%E7%BC%96%E7%A0%81%22%5D';
        String url = 'https://open.feishu.cn/open-apis/bitable/v1/apps/' + appToken + '/tables/' + tableId + '/records?page_size=' + pageSize + '&field_names=' + fieldNames + '&automatic_fields=true&filter=' + filter + '&page_token=' + pageToken;
        HttpResponse response;
        try{
            response = httpRequest(url);
        } catch(Exception e) {
            // return new ResultMap(0, e.getMessage(), null);
        }

        Map<String, Object> retrunMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> data = retrunMap.get('data') == null? new Map<String, Object>() : (Map<String, Object>) retrunMap.get('data');
        List<Object> items = data.get('items') == null? new List<Object>() : (List<Object>) data.get('items');
        for (Object item : items) {
            Map<String, Object> itemMap = (Map<String, Object>) item;
            Map<String, Object> fields = itemMap.get('fields') == null?null:(Map<String, Object>) itemMap.get('fields');
            temp.put((String) fields.get('商机编码'),(String) fields.get('评审结论'));
        }

        // if (temp.values().size() > 0) {
        //     List<Opportunity> updateOppList = new List<Opportunity>();
        //     String sql = 'SELECT Id, HQ_Review_Result__c, feishuId__c, History_Code__c FROM Opportunity WHERE History_Code__c = \'' + code +'\'';
        //     List<Opportunity> oppList = Database.query(sql);
        //     for(Opportunity opp :oppList){
        //         opp.HQ_Review_Result__c = temp.get(code);
        //         updateOppList.add(opp);
        //     }
        //     Database.SaveResult[] srList = Database.update(updateOppList, false);
        //     Set<String> updataIdList = new Set<String>();
        //     for(Opportunity opportunity : updateOppList){
        //         updataIdList.add(opportunity.Id);
        //     }

        //     for(Database.SaveResult sr : srList) {
        //         if (sr.isSuccess()) {
        //             updataIdList.remove(sr.getId());
        //         }
        //     }
        //     String errIds = '';
        //     for(String id : updataIdList){
        //         errIds = errIds + id + ';';
        //     }
        //     if(errIds != ''){
        //         Interface_Log__c log = new Interface_Log__c();
        //         log.errMsg__c = '更新时间:' + Datetime.now() + '更新错误记录id' + errIds;
        //         INSERT log;
        //     }
        // }
        // return new ResultMap(1, '', temp);
    }


    /**
     * 获取访问接口token
     */
    public static String getToken(){
        Map<String, String> body = new Map<String, String>();
        body.put('app_secret', appSecret);
        body.put('app_id', appId);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Length', '0');
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setBody(JSON.serialize(body));
        Http http = new Http();
        HttpResponse response = http.send(req);
        if(response.getStatusCode() != 200){
                //异常由发起请求处做处理
                throw new HttpException(response.getStatusCode(),response.getStatus());
        }
        Map<String, Object> retrunMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return  'Bearer ' + retrunMap.get('tenant_access_token');
    }


    /**
     * HTTPGET请求公共方法
     */
    public static HttpResponse httpRequest(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Length', '0');
        req.setHeader('Authorization', getToken());
        req.setMethod('GET');
        req.setTimeout(120000);

        Http http = new Http();
        HttpResponse response = http.send(req);
        if(response.getStatusCode() != 200){
                //异常由发起请求处做处理
                throw new HttpException(response.getStatusCode(),response.getStatus());
        }
        return response;
    }

    //自定义异常类
    public class HttpException extends Exception{
        public Integer code;
        public HttpException(Integer code, String message){
            this(message);
            this.code = code;
        }
    }

    //自定义异常类
    public class ResultMap{
        public Integer errorCode;
        public String errorMsg;
        public Map<String, String> hqReviewResult;
        public ResultMap(Integer errorCode, String errorMsg, Map<String, String> hqReviewResult) {
            this.errorCode = errorCode;
            this.errorMsg = errorMsg;
            this.hqReviewResult = hqReviewResult;
        }
    }
}