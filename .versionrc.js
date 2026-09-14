const versionFile = {
  filename: 'version',
  updater: {
    readVersion(contents) {
      return contents.trim();
    },
    writeVersion(_contents, version) {
      return `${version}\n`;
    },
  },
};

module.exports = {
  packageFiles: [versionFile],
  bumpFiles: [versionFile],
};
