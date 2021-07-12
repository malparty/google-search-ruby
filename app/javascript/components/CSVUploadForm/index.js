const SELECTORS = {
  fileInput: '.form-csv-upload__input-file'
};

class CSVUploadForm {
  constructor(elementRef) {
    this.csvUploadForm = elementRef;
    this.fileInput = elementRef.querySelector(SELECTORS.fileInput);

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
