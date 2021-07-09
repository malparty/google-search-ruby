const SELECTORS = {
  fileInput: '#csv_upload_form_file'
};

class CSVUploadForm {
  constructor(csvUploadForm) {
    this.csvUploadForm = csvUploadForm;
    this.fileInput = csvUploadForm.querySelector(SELECTORS.fileInput)

    this._setup();
  }

  // private

  _setup() {
    this._registerOnFileChangeEvent();
  }

  _registerOnFileChangeEvent() {
    document.addEventListener('DOMContentLoaded', () => {
      // Csv File upload form - submit when file selected
      this.fileInput.onchange = () => {
        this.csvUploadForm.submit();
      };
    });
  }
}
