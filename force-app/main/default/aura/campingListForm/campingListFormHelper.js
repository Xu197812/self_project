({
    createItem : function(component,event,newCamping) {
        console.log(newCamping)
        let addItem = component.getEvent("addItem");
        addItem.setParams({"item":newCamping})
        addItem.fire();
        component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                                       'Name': '',
                                       'Quantity__c': 0,
                                       'Price__c': 0,
                                       'Packed__c': false});
    }
})