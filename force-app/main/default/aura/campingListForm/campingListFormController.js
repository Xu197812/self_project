({
    clickCreateItem : function(component, event, helper) {
        let validcamping = component.find('campingform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
         if(validcamping){
            let newCamping = component.get("v.newItem");
            helper.createItem(component,event,newCamping);
         }

        
        
    }
})