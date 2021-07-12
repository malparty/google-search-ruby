const SELECTORS = {
  fileInput: '#csv_upload_form_file'
};

class CSVUploadForm {
  constructor(csvUploadForm) {
    this.csvUploadForm = csvUploadForm;
    this.fileInput = csvUploadForm.querySelector(SELECTORS.fileInput);

    this._setup();
  }

  // private

  _setup() {
    this._registerOnFileChangeEvent();
  }

  _registerOnFileChangeEvent() {
    // Submit form when a file is selected
    this.fileInput.onchange = () => {
      this.csvUploadForm.submit();
    };
  }
}

export default CSVUploadForm;
