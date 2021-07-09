import CSVUploadForm from 'Components/CSVUploadForm';

const SELECTORS = {
  csvUploadForm: '#new_CSVUploadForm'
};

class KeywordsScreen {
  constructor() {
    this.csvUploadForm = document.querySelector(SELECTORS.csvUploadForm);

    this._setup();
  }

  // private

  _setup() {
    new CSVUploadForm(this.csvUploadForm);
  }
}
