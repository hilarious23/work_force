const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

//get path to build folder.
const buildPath = path.resolve(__dirname, 'build');
//call a function on the fs module to remove entire direvtor, everything
//removeSync us included with this fs extra module
fs.removeSync(buildPath);

//Read 'Campaign.sol' from the 'contract' folder
const factoryPath = path.resolve(__dirname, 'contracts', 'Factory.sol');
const source = fs.readFileSync(factoryPath, 'utf8');

//assign contract property to putput
const output = solc.compile(source, 1).contracts;

//Re-create build folder
fs.ensureDirSync(buildPath);

//contractはここではCampaign, CampaignFactory
for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(':', '') + '.json' ),
    //上記のフォルダにoutputディクショナリのcontractに対するvalueを格納
    output[contract]
  );
}