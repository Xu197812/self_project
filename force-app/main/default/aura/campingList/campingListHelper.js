({
    // selectCampings : function(component,event) {
    //     let action = component.get("c.getItems");
    //     action.setCallback(this, function(response){
    //     let state = response.getState();
    //     if (state === "SUCCESS") {
    //         // let campings = component.get("v.items");
    //         component.set("v.items", response.getReturnValue());
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },

    createItem : function(component,event,newCamping) {
        let action = component.get("c.saveItem");
        action.setParams({
            "item": newCamping
        });
        action.setCallback(this, function(response){
            let state = respsonse.getState();
            if (state==="SUCCESS") {
                let campings = component.get("v.items");
                campings.push(response.getReturnValue());
                component.set("v.items", campings);
            }
        });
        $A.enqueueAction(action);
    }
})