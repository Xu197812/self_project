import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import SearchAccountByName from '@salesforce/apex/AccountController.SearchAccountByName';
import SearchAccountList from '@salesforce/apex/AccountController.SearchAccountList';
export default class MyTestVariable extends LightningElement {
    @track accName;
    @track datas;
    @track AccountList;
    @track Checklist;



    connectedCallback(){
        //加载单选框
        // for(let i = 0; i<AccountList.length; I++){
        //    Checklist.push('false');
        // }
        
        //加载表格数据
        SearchAccountList()
        .then(result=>{
            this.AccountList = result;
        }).catch(error=>{

        })
    }

    check(event){
        const selectedRows = event.detail;
        console.log("1233213");
        console.log(selectedRows);
    }

    searchAcc() {
        
        let username = this.template.querySelector('lightning-input[data-id=inputvalue]').value;    
    	console.log(username);
        
        const _this = this;


        var method = SearchAccountByName;
        var callback = function (response) {
            console.log('response',JSON.stringify(response));
            _this.AccountList = response;
        };
        var param = {
            accName: username
        };
        _this.callServer(method, callback, param);
    }

    callServer(method, callback, params) {
        const _this = this;
        _this.loaded = true;
        method(params) 
        .then(result => {
            console.log('result',JSON.stringify(result));
            callback.call(_this,result)
        }).catch(error => {
           _this.showNotification("错误", error, "error");
        });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

}