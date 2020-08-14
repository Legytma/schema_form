'use strict';

// standard-version-updater.js
const regexPuspecLockVersion = new RegExp(['(schema_form:.*source:\\s*path\\',
  's*version:\\s")((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9',
  ']\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA',
  '-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?)(?=")'].join(''),
  'gs');

module.exports.readVersion = function(contents) {
  const result = regexPuspecLockVersion.exec(contents);

  return result[2];
};

module.exports.writeVersion = function(contents, version) {
  return contents.replace(regexPuspecLockVersion, `$1${version}`);
};
