import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from '@salesforce/apex';
import SearchAccountByName from '@salesforce/apex/AccountController.SearchAccountByName';
import SearchTotal from '@salesforce/apex/AccountController.SearchTotal';
import DelAccList from '@salesforce/apex/AccountController.DelAccList';
const columns = [
	  { label: '客户名称', fieldName: 'Name' },
	  { label: 'Phone', fieldName: 'Phone', type: 'text' },
	  { label: 'Industry', fieldName: 'Industry', type: 'text' },
	  { label: 'Type', fieldName: 'Type'},
	  // { label: 'CloseDate', fieldName: 'closeDate', type: 'date' },
	];
export default class account_table extends LightningElement {
	@track data = [];
	@track accName;
	@track limitdata = [];
	@track pageSize = 10;
	@track pageNo = 1;
    @track total;
    @track delList;
    columns = columns;
   	connectedCallback() {
    	this.searchAcc();
        this.searchTotalAcc();
    }

    searchTotalAcc(){
        const _this = this;
        _this.loaded = true;
        SearchTotal()
        .then(result => {
            _this.total = result;
        }).catch(error => {
           _this.showNotification("错误", "error", "error");
        });
    }
    //查询客户
    searchAcc(){    
        const _this = this;
        let method = SearchAccountByName;
        let callback = function (response) {
            _this.data = response;
        };
        let param = {
            accName: this.accName,
            yedaxiao: this.pageSize,
            dijiye: this.pageNo
        };
        _this.callServer(method, callback, param);
    }
	//获取前端中被选中的行
	getSelectedRecords(event) {
	    // 获取被选中的数据，这是一个list
	    const selectedRows = event.detail.selectedRows;
	    console.log(selectedRows);
        this.delList=selectedRows;
        console.log(JSON.stringify(this.delList));
	}
    delSelectedRecords(){
        let method = DelAccList;
		this.accName = event.target.value;
        let callback = function (response) {
            this.searchAcc();
            this.refreshData();
        };
        let param = {
            delList: this.delList,
        };
        this.callServer(method, callback, param);
    }
    //输入框值改变js中变量发生改变
    changeinput(event){
		// console.log(event.target.value);
	}
    changepageno(event){
        this.pageNo = event.target.value;
        this.searchAcc();
    }
    changepagesize(event){
        this.pageSize = event.target.value;
        this.searchAcc();
    }

	prepage(){
        console.log("1");
		if (this.pageNo==1) {
            console.log("1");
			this.showNotification("已经是第一页", "错误", "error");
		}else{
            console.log("1");
            this.pageNo = this.pageNo - 1;
            let method = SearchAccountByName;
            let callback = function (response) {
                this.data = response;
            };
            let param = {
                accName: this.accName,
                yedaxiao: this.pageSize,
                dijiye: this.pageNo
            };
            this.callServer(method, callback, param);
        }

	}
	nextpage(){
		console.log("1");
        this.pageNo = this.pageNo + 1;
        let method = SearchAccountByName;
        let callback = function (response) {
            this.data = response;
        };
        let param = {
            accName: this.accName,
            yedaxiao: this.pageSize,
            dijiye: this.pageNo
        };
        this.callServer(method, callback, param);
	}





//**************************公共方法***************************************
    callServer(method, callback, params) {
        const _this = this;
        _this.loaded = true;
        method(params) 
        .then(result => {
            // console.log('result',JSON.stringify(result));
            callback.call(_this,result)
        }).catch(error => {
           _this.showNotification("错误", "error", "error");
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

    refreshData() {
        return refreshApex(this.limitdata);
    }

}