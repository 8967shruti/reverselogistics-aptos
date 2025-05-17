
![Screenshot 2025-05-17 132752](https://github.com/user-attachments/assets/fccc1d56-afc6-409b-9dca-eb9776c7cd7e)

ReverseLogistics Smart Contract
A Move-based smart contract for Aptos blockchain that facilitates reverse logistics processes for product returns and repairs.
Overview
This smart contract enables businesses to efficiently manage their return and repair processes on the Aptos blockchain. It provides a transparent, immutable record of all return/repair requests and their statuses, streamlining communication between customers and merchants.
Features

Create return or repair requests with detailed information
Track request status (Pending, Approved, Rejected, Completed)
Maintain a permanent record of all logistics activities
Simple and efficient implementation (under 50 lines of core logic)

Contract Structure
Key Data Structures

ReturnRequest: Stores all information about a return or repair request

request_id: Unique identifier for each request
customer: Address of the customer who initiated the request
item_id: Identifier for the item being returned/repaired
is_repair: Boolean flag to distinguish between returns and repairs
reason: Customer-provided reason for the return/repair
status: Current status of the request
created_at: Timestamp when the request was created


RequestCounter: Generates unique request IDs

count: A counter that increments with each new request



Status Codes

STATUS_PENDING (0): Initial state when a request is first created
STATUS_APPROVED (1): Request has been approved by the merchant
STATUS_REJECTED (2): Request has been rejected by the merchant
STATUS_COMPLETED (3): Return/repair process has been completed

Error Codes

ERR_NOT_AUTHORIZED (101): Caller doesn't have permission for the operation
ERR_REQUEST_NOT_FOUND (102): The specified request doesn't exist
ERR_INVALID_STATUS (103): An invalid status value was provided

Functions
initialize
movepublic fun initialize(merchant: &signer)
Sets up the contract for a merchant by initializing the request counter.
Parameters:

merchant: The signer representing the merchant/business account

create_request
movepublic fun create_request(
    customer: &signer,
    merchant: address,
    item_id: String,
    is_repair: bool,
    reason: String
)
Creates a new return or repair request.
Parameters:

customer: The signer representing the customer's account
merchant: The address of the merchant handling the request
item_id: Identifier for the item being returned/repaired
is_repair: If true, this is a repair request; if false, it's a return request
reason: Description of why the item is being returned or repaired

update_request_status
movepublic fun update_request_status(
    merchant: &signer,
    customer: address,
    request_id: u64,
    new_status: u8
)
Updates the status of an existing request.
Parameters:

merchant: The signer representing the merchant's account
customer: The address of the customer who created the request
request_id: The unique identifier of the request to update
new_status: The new status value to assign (must be a valid status code)

Usage Example
move// Initialize the contract for a merchant
initialize(&merchant_signer);

// Customer creates a return request
create_request(
    &customer_signer,
    merchant_address,
    string::utf8(b"PRODUCT123"),
    false, // false for return, true for repair
    string::utf8(b"Defective product")
);

// Merchant approves the request
update_request_status(
    &merchant_signer,
    customer_address,
    0, // request_id
    STATUS_APPROVED
);

// Later, merchant marks the return as completed
update_request_status(
    &merchant_signer,
    customer_address,
    0, // request_id
    STATUS_COMPLETED
);
Installation and Deployment

Clone this repository
Compile the Move module:
aptos move compile --named-addresses MyModule=<YOUR_ADDRESS>

Test the module:
aptos move test

Publish the module to the Aptos blockchain:
aptos move publish --named-addresses MyModule=<YOUR_ADDRESS>


License
MIT License
Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

Contract address : "0xd8167b5bde71385b30407ddf15f7d5bcd231ed17d2b382c0228474053475de4b"
