({
    createItem : function(component, event, helper) {
        //component.find()寻找component中元素
        let validcamping = component.find('campingform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validcamping){
            // Create the new expense
            let newCamping = component.get("v.newItem"); 
            helper.createItem(component,event,newCamping);
            // reset form
            component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                                   'Name': '',
                                   'Quantity__c': 0,
                                   'Price__c': 0,
                                   'Packed__c': false});
        }
    },
    doInit:function(component, event, helper){
        let action = component.get("c.getItems");
        action.setCallback(this, function(response){
        let state = response.getState();
        if (state === "SUCCESS") {
            // let campings = component.get("v.items");
            component.set("v.items", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    handleAddItem : function(component, event, helper){
        let newCamping = event.getParam("item");
        let action = component.get("c.saveItem");
        action.setParams({
            "item": newCamping
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state==="SUCCESS") {
                let campings = component.get("v.items");
                campings.push(newCamping);
                component.set("v.items", campings);
            }
        });
        $A.enqueueAction(action);
    }
})