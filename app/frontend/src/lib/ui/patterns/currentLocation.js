import '../../polyfill/classlist.polyfill';
import '../../polyfill/after.polyfill';
import '../../polyfill/remove.polyfill';
import '../../../loader';
import { getPostcodeFromCoordinates } from '../../api';
import { enableRadiusSelect, disableRadiusSelect } from '../../../search/ui/input/radius';
import Rollbar from '../../logging';

const loader = new GOVUK.Loader();

const containerEl = document.getElementsByClassName('js-location-finder')[0];
const inputEl = document.getElementsByClassName('js-location-finder__input')[0];

export const ERROR_MESSAGE = 'Unable to find your location';
export const LOGGING_MESSAGE = '[Module: currentLocation]: Unable to find user location';

export const startLoading = (container, input) => {
  input.disabled = true;
  container.classList.add('js-location-finder--loading');
  loader.init({
    container: 'js-location-finder__input-container',
    size: 32,
    label: true,
    labelText: 'Finding location...',
  });
};

export const stopLoading = (container, input) => {
  loader.stop();
  container.classList.remove('js-location-finder--loading');
  input.removeAttribute('disabled');
};

export const showLocationLink = (container) => {
  container.classList.add('js-geolocation-supported');
};

export const showErrorMessage = (link) => {
  if (!document.querySelector('.js-location-finder__link .govuk-error-message')) {
    const errorMessage = document.createElement('div');
    errorMessage.classList.add('govuk-error-message');
    errorMessage.classList.add('govuk-!-margin-top-2');
    errorMessage.innerHTML = ERROR_MESSAGE;
    link.after(errorMessage);
  }
};

export const removeErrorMessage = () => {
  if (document.querySelector('.js-location-finder__link .govuk-error-message')) {
    document.querySelector('.js-location-finder__link .govuk-error-message').remove();
  }
};

export const onSuccess = (postcode, element) => {
  element.value = postcode;
  enableRadiusSelect();
  currentLocation.stopLoading(containerEl, inputEl);
};

export const onFailure = () => {
  currentLocation.showErrorMessage(document.getElementById('current-location'));
  disableRadiusSelect();
  currentLocation.stopLoading(containerEl, inputEl);
  Rollbar.log(LOGGING_MESSAGE);
};

export const postcodeFromPosition = (position, apiPromise) => apiPromise(position.coords.latitude, position.coords.longitude).then((response) => {
  if (response && response.result) {
    onSuccess(response.result[0].postcode, document.getElementById('location'));
  } else {
    onFailure();
  }
}).catch(() => {
  onFailure();
});

export const init = () => {
  document.getElementById('current-location').addEventListener('click', (event) => {
    event.stopPropagation();

    startLoading(containerEl, inputEl);

    navigator.geolocation.getCurrentPosition((data) => {
      postcodeFromPosition(data, getPostcodeFromCoordinates);
    }, () => {
      stopLoading(containerEl, inputEl);
      showErrorMessage(document.getElementById('current-location'));
    });
  });

  inputEl.addEventListener('focus', () => {
    removeErrorMessage();
  });
};

const currentLocation = {
  showErrorMessage,
  stopLoading,
  onSuccess,
  init,
};

export default currentLocation;

window.addEventListener('DOMContentLoaded', () => {
  if (navigator.geolocation && containerEl) {
      showLocationLink(containerEl);
      init();
  }
});