module ReverseLogisticsModule::ReverseLogistics {
    use std::string::{String};
    use aptos_framework::signer;
    use aptos_framework::timestamp;

    /// Status of a return or repair request
    const STATUS_PENDING: u8 = 0;
    const STATUS_APPROVED: u8 = 1;
    const STATUS_REJECTED: u8 = 2;
    const STATUS_COMPLETED: u8 = 3;

    /// Error codes
    const ERR_NOT_AUTHORIZED: u64 = 101;
    const ERR_REQUEST_NOT_FOUND: u64 = 102;
    const ERR_INVALID_STATUS: u64 = 103;

    /// Struct representing a return or repair request
    struct ReturnRequest has store, key {
        request_id: u64,           // Unique identifier for the request
        customer: address,         // Address of the customer who initiated the request
        item_id: String,           // Identifier for the item being returned/repaired
        is_repair: bool,           // True if repair request, false if return request
        reason: String,            // Reason for return/repair
        status: u8,                // Current status of the request
        created_at: u64,           // Timestamp when request was created
    }

    /// Counter to generate unique request IDs
    struct RequestCounter has key {
        count: u64
    }

    /// Initialize the module for the merchant
    public fun initialize(merchant: &signer) {
        let counter = RequestCounter { count: 0 };
        move_to(merchant, counter);
    }

    /// Function for customers to create a new return or repair request
    public fun create_request(
        customer: &signer,
        merchant: address,
        item_id: String,
        is_repair: bool,
        reason: String
    ) acquires RequestCounter {
        let customer_addr = signer::address_of(customer);
        
        // Get the next request ID
        let counter = borrow_global_mut<RequestCounter>(merchant);
        let request_id = counter.count;
        counter.count = request_id + 1;
        
        // Create the request
        let request = ReturnRequest {
            request_id,
            customer: customer_addr,
            item_id,
            is_repair,
            reason,
            status: STATUS_PENDING,
            created_at: timestamp::now_seconds(),
        };
        
        // Store the request at the merchant's address
        move_to(customer, request);
    }

    /// Function for merchant to update the status of a return/repair request
    public fun update_request_status(
        merchant: &signer,
        customer: address,
        request_id: u64,
        new_status: u8
    ) acquires ReturnRequest {
        // Verify the merchant is authorized
        let merchant_addr = signer::address_of(merchant);
        
        // Get the request
        let request = borrow_global_mut<ReturnRequest>(customer);
        assert!(request.request_id == request_id, ERR_REQUEST_NOT_FOUND);
        
        // Update the status
        assert!(new_status <= STATUS_COMPLETED, ERR_INVALID_STATUS);
        request.status = new_status;
    }
}