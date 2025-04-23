import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-cancel"
export default class extends Controller {
  connect() {
    console.log('cancel me');
  }
  
  cancel(event) {
    event.target.closest('form').classList.add('hidden');
    event.preventDefault();
  }
}
