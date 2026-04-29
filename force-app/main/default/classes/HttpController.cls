/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/rest')
global with sharing class HttpController {
    @HttpPost
    global static String doPost() {
        return '徐帆环境的接口';
    }
}