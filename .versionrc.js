// Release configuration for commit-and-tag-version.
//
// The config declares every version surface the release tool owns. Besides the
// framework version file, this includes the prose version line in the bundled
// agent skill so it cannot drift from the released version.

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

// Builds an updater for a file whose version appears as the second capture
// group, wrapped by a stable prefix (first group) and suffix (third group).
const textVersion = (pattern) => ({
  readVersion(contents) {
    const match = contents.match(pattern);
    if (!match) {
      throw new Error(`version pattern not found: ${pattern}`);
    }
    return match[2];
  },
  writeVersion(contents, version) {
    return contents.replace(pattern, (_match, prefix, _current, suffix) => `${prefix}${version}${suffix}`);
  },
});

const skillVersion = textVersion(/(This skill describes SolverForge Linux `)(\d+\.\d+\.\d+)(`)/);

module.exports = {
  packageFiles: [versionFile],
  bumpFiles: [
    versionFile,
    { filename: 'skills/solverforge-linux/SKILL.md', updater: skillVersion },
  ],
};
