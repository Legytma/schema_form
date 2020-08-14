'use strict';

// standard-version-updater.js
const regexReadmeVersion = new RegExp(['(^\\s*schema_form:\\s+\\^)((0|[1-9]',
  '\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a',
  '-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-',
  'zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?)(?=$)'].join(''), 'gm');

module.exports.readVersion = function(contents) {
  const result = regexReadmeVersion.exec(contents);

  return result[2];
};

module.exports.writeVersion = function(contents, version) {
  return contents.replace(regexReadmeVersion, `$1${version}`);
};
