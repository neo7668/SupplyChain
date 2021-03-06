pragma solidity ^0.4.18;
import "./Authorizer.sol";
import "./Owned.sol";
import "./Inventory.sol";

contract OperationTeam is Owned {
    
    Authorizer Auth;
    Inventory Invt;
    // address WH;

    bytes32[] operationTeams;

    // address[] tempAddArray;
    // bytes32[] tempBytesArray;
    // uint256[] tempUintArray;
    // uint256 priceCalculator;

    struct OperationTeamInfo {
        address teamLead;
        address[] teamMembers;
        bytes32 teamName;
        bytes32 operationName;
        bytes32[] rawMaterialGroupID;
        uint256[] rawMaterialUnits;
        bytes32 productDescription;
    }
    
    // struct FinalProduct {
    //     bytes32 productID;
    //     // bytes32 parent;
    //     // bytes32 name;
    //     bytes32 groupID;
    //     // address currentOwner;
    //     // address supplier;
    //     bytes32[] childs;
    //     bytes32 additionalDiscription;
    //     uint256 price;
    //     // bytes32 inventoryStoreID;
    //     bool isConsume;
    // }

    // struct FinalProductsArray {
    //     uint256 units;
    //     bytes32[] FinalProductIDs;
    // }


    mapping(bytes32 => OperationTeamInfo) operationDetails;
    // mapping(bytes32 => FinalProduct) manufacturedProducts;
    // mapping(bytes32 => FinalProductsArray) finalProductsArray;

    function OperationTeam(
        address _authorizerContractAddress//,
        //address _inventoryContractAddress,
        //address _warehouseContractAddress
    ) public {
        Auth = Authorizer(_authorizerContractAddress);
        // Invt = Inventory(_inventoryContractAddress);
        // WH = _warehouseContractAddress;
    }

    function setInventoryContractAddress(
        address _inventoryContractAddress
    )
        public
        onlyOwner
        returns(
            bool
        ) {
        Invt = Inventory(_inventoryContractAddress);
    }
    
    function registerOperationTeam(
        address _teamLead,
        address[] _teamMembers,
        bytes32 _teamName,
        bytes32 _operationName,
        bytes32[] _rawMaterialGroupID,
        uint256[] _rawMaterialUnits,
        bytes32 _productDescription
    )
        public
        returns( 
            bool 
            ) {
        require(Auth.isRegistrar(msg.sender));
        if (operationDetails[_operationName].operationName != "") {
            return false;
        } else {
            OperationTeamInfo memory newOperationTeamInfo;
            newOperationTeamInfo.teamLead = _teamLead;
            newOperationTeamInfo.teamMembers = _teamMembers;
            newOperationTeamInfo.teamName = _teamName;
            newOperationTeamInfo.operationName = _operationName;
            newOperationTeamInfo.rawMaterialGroupID = _rawMaterialGroupID;
            newOperationTeamInfo.rawMaterialUnits = _rawMaterialUnits;
            newOperationTeamInfo.productDescription = _productDescription;            
            operationDetails[_operationName] = newOperationTeamInfo;
            operationTeams.push(_operationName);
            return true;
        }
    }

    function isOperator(bytes32 _operationName,address operationLeadAddress) public constant returns(bool) {
        if (operationDetails[_operationName].teamLead == operationLeadAddress) {
            return true;
        } else {
            return false;
        }
    }

    function makeFinalProducts(
        bytes32 _operationName,
        bytes32 _inventoryID,
        uint256 _units
    )
        public
        returns(
            bool
        ) {
        return (Invt.getRawMaterialsFromInventory(msg.sender,_operationName,_inventoryID,_units,operationDetails[_operationName].rawMaterialGroupID,operationDetails[_operationName].rawMaterialUnits,operationDetails[_operationName].productDescription));
    }
    // function getRawMaterialsFromInventory(
    //     bytes32 _operationName,
    //     bytes32 _inventoryID,
    //     uint256 _units
    // )
    //     public
    //     returns(
    //         bytes32[] _finalProductID
    //     ) {
    //     require(operationDetails[_operationName].teamLead == msg.sender);
    //     priceCalculator = 0;
    //     for (uint i = 0; i < operationDetails[_operationName].rawMaterialGroupID.length;i++) {
    //         tempBytesArray = Invt.getRawMaterialFromInventory(_inventoryID,operationDetails[_operationName].rawMaterialGroupID[i],operationDetails[_operationName].rawMaterialUnits[i])[0];
    //         priceCalculator += Invt.getRawMaterialFromInventory(_inventoryID,operationDetails[_operationName].rawMaterialGroupID[i],operationDetails[_operationName].rawMaterialUnits[i])[1];            
    //     }
    //     bytes32 _productID = keccak256(tempBytesArray.length,tempBytesArray);
    //     FinalProduct memory newFinalProduct;
    //     newFinalProduct.productID = _productID;
    //     // newFinalProduct.parent = "Final Product";
    //     newFinalProduct.groupID = _operationName;
    //     newFinalProduct.childs = tempBytesArray;
    //     newFinalProduct.additionalDiscription = operationDetails[_operationName].productDescription;
    //     newFinalProduct.price = priceCalculator;
    //     manufacturedProducts[_productID] = newFinalProduct;
    //     finalProductsArray[_operationName].units += 1;
    //     finalProductsArray[_operationName].FinalProductIDs.push(_productID);
    // }

    // function getManufacturedProducts(
    //     bytes32 _operationName
    // )
    //     public
    //     constant
    //     returns(
    //         bytes32[] finalProductIDs,
    //         uint256 unitsAvailable
    //     ) {
    //     return(finalProductsArray[_operationName].FinalProductIDs,finalProductsArray[_operationName].units);
    // }


}