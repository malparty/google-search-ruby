import CSVUploadForm from '../../components/CSVUploadForm';

const SELECTORS = {
  screen: '.screen-keyword',
  csvUploadForm: '.form-csv-upload'
};

class KeywordScreen {
  constructor() {
    this.csvUploadForm = document.querySelector(SELECTORS.csvUploadForm);

    this._setup();
  }

  // private

  _setup() {
    new CSVUploadForm(this.csvUploadForm);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const isKeywordScreen = document.querySelector(SELECTORS.screen) !== null;

  if (isKeywordScreen) {
    new KeywordScreen();
  }
});
