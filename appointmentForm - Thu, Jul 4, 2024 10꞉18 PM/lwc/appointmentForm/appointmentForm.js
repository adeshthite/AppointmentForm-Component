import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import appoappointment from '@salesforce/apex/AppointmentSlotApex.appoappointment';
import checkDuplicateAppointment from '@salesforce/apex/AppointmentSlotApex.checkDuplicateAppointment';



export default class AppointmentForm extends  LightningElement {

   @track error;
    result;
    dateCount;

    appoinmentDates;
    handltime;
   


    @wire(appoappointment)
    wiredAppointments({ error, data }) {
        if (data) {
            this.dates = data;
            this.dateCount = data.length;
        } else if (error) {
            console.error('Error fetching appointments:', error);
        }
    }

   
    appoinmentDate() {
        this.appoinmentDates = event.target.value;
        //  alert(event.target.value);
     
    }

    appoinmentTime() {
        this.handltime = event.target.value;
        //alert(event.target.value);

    }

    
    handleSubmit(event) {

        event.preventDefault();
        const fields = event.detail.fields;

        const timeString = this.handltime;

        checkDuplicateAppointment({ appoinmentTimes: timeString, appoinmentDatess: this.appoinmentDates })
            .then(result => {
                if (result) {
                    console.log(this.result);
                    this.showToast('An appointment at the selected date and time already exists', 'An appointment at the selected date and time already exists.', 'error');
                } else {
                    this.template.querySelector('lightning-record-edit-form').submit(fields);
                }
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });


      //  window.location.reload();

    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message, 
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    handleSucess(event) {

        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);

        const event1 = new ShowToastEvent({
            title: 'Record  Created is Successfully',
            message: 'Appointment has been scheduled',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event1);


     }

}