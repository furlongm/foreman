/* eslint-disable func-names */
import $ from 'jquery';

import store from './react_app/redux';
import { actions as TemplateActions } from './react_app/components/TemplateGenerator';

export function initTypeChanges() {
  // update the hidden input which serves as template
  // and also all existing inputs in case of editing
  $('select.input_type_selector').each(function() {
    updateVisibilityAfterInputTypeChange($(this));
  });

  // every additional input that's added through "Add Input" button will also be handled
  $(document).on('change', 'select.input_type_selector', function() {
    updateVisibilityAfterInputTypeChange($(this));
  });
}

function updateVisibilityAfterInputTypeChange(select) {
  const fieldset = select.closest('fieldset');
  fieldset.find('div.custom_input_type_fields').hide();
  fieldset.find(`div.${select.val()}_input_type`).show();
}

export const toggleEmailFields = checkbox => {
  const $checkbox = $(checkbox);
  $checkbox
    .closest('form')
    .find('.email-fields')
    .toggle($checkbox.is(':checked'));
};

export const generateTemplate = (url, templateInputData) => {
  store.dispatch(TemplateActions.generateTemplate(url, templateInputData));
};

export const pollReportData = url => {
  store.dispatch(TemplateActions.pollReportData(url));
};
