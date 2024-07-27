public class AccountManager {
    
    // Method to handle bulk insert/update of accounts
    public static void upsertAccounts(List<Account> accountsToUpsert) {
        try {
            upsert accountsToUpsert;
        } catch (DmlException e) {
            System.debug('Error during upsert: ' + e.getMessage());
            throw e; // Re-throw the exception for higher-level handling
        }
    }

    // Method to delete accounts and associated contacts
    public static void deleteAccountsWithContacts(List<Id> accountIds) {
        try {
            List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
            delete contactsToDelete;
            
            List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Id IN :accountIds];
            delete accountsToDelete;
        } catch (DmlException e) {
            System.debug('Error during deletion: ' + e.getMessage());
            throw e;
        }
    }

    // Method to get a list of accounts with a specific rating
    public static List<Account> getAccountsByRating(String rating) {
        return [SELECT Id, Name, Rating FROM Account WHERE Rating = :rating];
    }
    
    // Method to update account ratings based on some business logic
    public static void updateAccountRatings(List<Account> accountsToUpdate) {
        for (Account acc : accountsToUpdate) {
            if (acc.AnnualRevenue > 1000000) {
                acc.Rating = 'Hot';
            } else {
                acc.Rating = 'Warm';
            }
        }
        try {
            update accountsToUpdate;
        } catch (DmlException e) {
            System.debug('Error during rating update: ' + e.getMessage());
            throw e;
        }
    }
    
    // Utility method to format account names
    public static String formatAccountName(String accountName) {
        if (String.isEmpty(accountName)) {
            return 'Unnamed Account';
        }
        return accountName.trim().toUpperCase();
    }

    // Example of an inner class used for utility functions
    public class AccountUtility {
        
        // Method to check if an account is high value based on annual revenue
        public static Boolean isHighValueAccount(Account acc) {
            return acc.AnnualRevenue > 5000000;
        }
        
        // Method to concatenate account name and industry for reporting
        public static String getAccountReportString(Account acc) {
            return acc.Name + ' - ' + acc.Industry;
        }
    }
    
    // Example of a nested class for custom exceptions
    public class AccountManagerException extends Exception {}
    
    // Method to handle a custom operation with exception handling
    public static void customOperation(List<Account> accounts) {
        try {
            // Simulate custom operation
            if (accounts.size() == 0) {
                throw new AccountManagerException('No accounts provided for the operation.');
            }
            // Perform some operation
            System.debug('Custom operation successful');
        } catch (AccountManagerException e) {
            System.debug('Custom operation failed: ' + e.getMessage());
        }
    }
    
}
