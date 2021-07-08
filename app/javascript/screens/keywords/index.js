import CSVUploadForm from '../../components/CSVUploadForm';
import KeywordCanvas from '../../components/KeywordCanvas';

const SELECTORS = {
  screen: '.screen-keywords',
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
    new KeywordCanvas();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const isKeywordsScreen = document.querySelector(SELECTORS.screen) !== null;

  if (isKeywordsScreen) {
    new KeywordsScreen();
  }
});
