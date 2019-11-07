GOOGLE_DRIVE_JSON_KEY = ENV['GOOGLE_DRIVE_JSON_KEY']
AUDIT_SPREADSHEET_ID = ENV['AUDIT_SPREADSHEET_ID']

AUDIT_GIDS = {
  vacancies: ENV['AUDIT_VACANCIES_WORKSHEET_GID'],
  vacancy_publish_feedback: ENV['AUDIT_VACANCY_PUBLISH_FEEDBACK_WORKSHEET_GID'],
  general_feedback: ENV['AUDIT_GENERAL_FEEDBACK_WORKSHEET_GID'],
  interest_expression: ENV['AUDIT_EXPRESS_INTEREST_WORKSHEET_GID'],
  subscription_creation: ENV['AUDIT_SUBSCRIPTION_CREATION_WORKSHEET_GID'],
  search_event: ENV['AUDIT_SEARCH_EVENT_WORKSHEET_GID']
}.freeze

DSI_USER_SPREADSHEET_ID = ENV['DSI_USER_SPREADSHEET_ID']
DSI_USER_WORKSHEET_GID = ENV['DSI_USER_WORKSHEET_GID']
DSI_APPROVER_WORKSHEET_GID = ENV['DSI_APPROVER_WORKSHEET_GID']
