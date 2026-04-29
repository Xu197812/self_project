import { LightningElement, api } from 'lwc';

export default class Tile extends LightningElement {
    @api product;
    connectedCallback() {
        console.log(this.product.fields.Picture_URL__c.value)

    }
    tileClick() {
        const event = new CustomEvent('tileclick', {
            // detail contains only primitives
            detail: this.product.fields.Id.value
        });
        // Fire the event from c-tile
        this.dispatchEvent(event);
    }
}