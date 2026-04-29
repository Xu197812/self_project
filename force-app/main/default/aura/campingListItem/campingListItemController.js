({
    packItem : function(component, event, helper) {
        component.set("v.item.Packed__c", true);
        let lable = event.getSource();
        //获取按钮的disable属性并设置为true
        event.getSource().set("v.disabled",true);
        // component.set("event.getSource().get("v.disabled")",true);
    }
})