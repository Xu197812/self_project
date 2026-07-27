/**
 * @description : Rest集成接口监听类
 * @author      : xufan
 * @created on  : 2026-06-19
 * @created by  : xufan
 * @test class  :
 * Ver          Date               Author                  Modification
 * 1.0          2026-06-19         xufan                   Initial Version
**/
@RestResource(urlMapping='/api/*')
global without sharing class ApiRestCallinListener {
    @TestVisible
    private final static String URLMAPPING = '/apii/';

    @HttpPost
    global static void doPost() {
        System.debug('webRequest');
        RestRequest webRequest = RestContext.request;
        System.debug('webRequest' + webRequest);
    }
}