/*
Table of Content

1-payments_accounting
  a-PROC_PAYMENT_SENT_ACCOUNT_DETAIL
  b-PROC_RECEIVE_MONEY_ACCOUNT_DETAIL
  c-PROC_PAYMENTS_ACCOUNT_DETAIL
  d-PROC_RECEIPTS_ACCOUNT_DETAIL
  e-PROC_CHARGES_ACCOUNT_DETAIL
  
2-Purchase_Accounting
  a-PROC_VENDOR_CREDIT_MEMO_ACCOUNT_DETAIL
  b-PROC_PARTIAL_CREDIT_ACCOUNT_DETAIL
  c-PROC_RECEIVE_ORDER_ACCOUNT_DETAIL
  
3-Sales_Accounting
  a-PROC_SALE_INVOICE_ACCOUNT_DETAIL
  b-PROC_SALE_RETURN_ACCOUNT_DETAIL
  c-PROC_REPLACEMENT_ACCOUNT_DETAIL
  
4-stock_accounting
  a-PROC_STOCK_TRANSFER_ACCOUNT_DETAIL
  b-PROC_STOCK_IN_ACCOUNT_DETAIL
  
5-Repair_Accounting
  a-PROC_REPAIR_IN_ACCOUNT_DETAIL
  b-PROC_REPAIR_OUT_ACCOUNT_DETAIL
  
6-Adjustment_Accounting
  a-PROC_ADJUSTMENT_ACCOUNT_DETAIL
  b-PROC_GENERAL_JOURNAL_ACCOUNT_DETAIL
 
*/


/*Payments_Accounting*/
drop procedure if Exists PROC_PAYMENT_SENT_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_PAYMENT_SENT_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
													  P_COL_VALUE TEXT,
													  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='PaymentSent';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

  SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 16) OR (A.GL_FLAG = 510) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 15) OR (A.GL_FLAG = 511) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM payments_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_RECEIVE_MONEY_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_RECEIVE_MONEY_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,P_COL_VALUE TEXT,P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='ReceiveMoney';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 19) OR (A.GL_FLAG =513) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 20) OR (A.GL_FLAG =512) THEN A.AMOUNT 
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM payments_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_PAYMENTS_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_PAYMENTS_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Payments';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;
   
 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 26) OR (A.GL_FLAG = 201) OR (A.GL_FLAG = '203') OR (A.GL_FLAG = 103) OR (A.GL_FLAG = 105) OR (A.GL_FLAG = 5553) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG= 101) OR (A.GL_FLAG = 23) OR (A.GL_FLAG=102) OR (A.GL_FLAG = 104) OR (A.GL_FLAG = 106) OR (A.GL_FLAG = 5554) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM payments_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_RECEIPTS_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_RECEIPTS_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Receipts';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 107) OR (A.GL_FLAG=204) OR (A.GL_FLAG=205) OR (A.GL_FLAG = 110) OR (A.GL_FLAG = 113) OR (A.GL_FLAG = 112)OR (A.GL_FLAG = 5551)  THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 29) OR (A.GL_FLAG = 28) OR (A.GL_FLAG=108) OR (A.GL_FLAG = 109) OR (A.GL_FLAG = 111) OR (A.GL_FLAG = 114) OR (A.GL_FLAG = 5552) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM payments_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;


drop procedure if Exists PROC_CHARGES_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_CHARGES_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Charges';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

   SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 89) OR (A.GL_FLAG = 116) OR (A.GL_FLAG = 117) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 90) OR (A.GL_FLAG = 115)  THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM payments_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

/*Payments_Accounting*/

/*Purchase_Accounting*/

drop procedure if Exists PROC_VENDOR_CREDIT_MEMO_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_VENDOR_CREDIT_MEMO_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='VendorCreditMemo';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

   SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 39) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 40) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Purchase_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;


drop procedure if Exists PROC_PARTIAL_CREDIT_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_PARTIAL_CREDIT_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='PartialCredit';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;


   SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 32) OR (A.GL_FLAG = 33) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 31) OR (A.GL_FLAG = 34) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Purchase_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_RECEIVE_ORDER_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_RECEIVE_ORDER_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='ReceiveOrder';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 37) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 38) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Purchase_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;
/*Purchase_Accounting*/

/*Sales_Accounting*/
drop procedure if Exists PROC_SALE_INVOICE_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_SALE_INVOICE_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Saleinvoice';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 41) OR (A.GL_FLAG = 43) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 42) OR (A.GL_FLAG = 44) OR (A.GL_FLAG = 79) OR (A.GL_FLAG = 80) OR (A.GL_FLAG = 81) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Sales_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_SALE_RETURN_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_SALE_RETURN_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Salereturn';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 45) OR (A.GL_FLAG = 48) OR (A.GL_FLAG = 82) OR (A.GL_FLAG = 83) OR (A.GL_FLAG = 84) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 46) OR (A.GL_FLAG = 47) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Sales_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

drop procedure if Exists PROC_REPLACEMENT_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_REPLACEMENT_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Replacement';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;
   SET P_GROUP_BY = 'ACC_ID, DESCRIPTION, GL_FLAG';
  
 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT,
                              GL_FLAG
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 49) OR (A.GL_FLAG = 52) OR (A.GL_FLAG = 53) OR (A.GL_FLAG = 55) OR (A.GL_FLAG = 100) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 50) OR (A.GL_FLAG = 51) OR (A.GL_FLAG = 54) OR (A.GL_FLAG = 56) OR (A.GL_FLAG = 86) OR (A.GL_FLAG = 87) OR (A.GL_FLAG = 85) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID,
                                      A.GL_FLAG
							     FROM (SELECT * FROM Sales_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;
/*Sales_Accounting*/

/*stock_accounting*/
drop procedure if Exists PROC_STOCK_IN_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_STOCK_IN_ACCOUNT_DETAIL` (P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag="'StockIn', 'TransientInventory'";
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

  SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
											WHEN (A.GL_FLAG = 64) OR (A.GL_FLAG = 5559) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
											WHEN (A.GL_FLAG = 62) OR (A.GL_FLAG = 5558) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM STOCK_ACCOUNTING 
										WHERE CASE
													WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
													WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
													ELSE FALSE
											  END
										  AND FORM_FLAG IN (",FormFlag,")
									  ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
                     
    PREPARE STMP FROM @QRY;
    EXECUTE STMP;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;


drop procedure if Exists PROC_STOCK_TRANSFER_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_STOCK_TRANSFER_ACCOUNT_DETAIL`( P_COL_NAME TEXT,
													   P_COL_VALUE TEXT,
													   P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='StockTransfer';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;


   SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 57) OR (A.GL_FLAG = 59) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 58) OR (A.GL_FLAG = 60) OR (GL_FLAG= 150) OR (GL_FLAG=151) THEN A.AMOUNT 
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM stock_accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

/*stock_accounting*/

/*Repair_Accounting*/
drop procedure if Exists PROC_REPAIR_IN_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_REPAIR_IN_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='RepairIn';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;


  SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 75) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 76) OR (A.GL_FLAG = 77) OR (A.GL_FLAG = 78) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Repair_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;


drop procedure if Exists PROC_REPAIR_OUT_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_REPAIR_OUT_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='RepairOut';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

  SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 74) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 73) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Repair_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;

/*Repair_Accounting*/

/*Here*/

/*Adjustment_Accounting*/
drop procedure if Exists PROC_ADJUSTMENT_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_ADJUSTMENT_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='Adjustment';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;
	SET P_GROUP_BY = 'ACC_ID, DESCRIPTION';

 SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT 
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 66) OR (A.GL_FLAG = 67) OR (A.GL_FLAG = 69)  THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 65) OR (A.GL_FLAG = 68) OR (A.GL_FLAG = 70) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID,
                                      A.GL_FLAG
							     FROM (SELECT * FROM Adjustment_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");
    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;


drop procedure if Exists PROC_GENERAL_JOURNAL_ACCOUNT_DETAIL;
DELIMITER $$
CREATE PROCEDURE `PROC_GENERAL_JOURNAL_ACCOUNT_DETAIL` ( P_COL_NAME TEXT,
																  P_COL_VALUE TEXT,
																  P_GROUP_BY TEXT )
BEGIN

	Declare FormFlag Text Default '';

    set FormFlag='GeneralJournal';
    
	IF P_COL_NAME = "" THEN
		SET P_COL_NAME = '-1';
	ELSE 
		SET P_COL_NAME = 'Form_Id';
    END IF;
    
    IF P_COL_VALUE = "" THEN
		SET P_COL_VALUE = '-1';
    END IF;
    
    IF P_GROUP_BY = "" THEN
		SET P_GROUP_BY = 'ID';
    END IF;

   SET @QRY = CONCAT("SELECT ACC_ID AS ACC_ID, 
							  DESCRIPTION AS DESCRIPTION, 
                              SUM(DEBIT) AS DEBIT, 
                              SUM(CREDIT) AS CREDIT
                             
					     FROM (SELECT A.FORM_ID,
								      A.FORM_DETAIL_ID,
								      C.ACC_ID AS ACC_ID,
								      C.DESCRIPTION AS DESCRIPTION,
								      CASE
										WHEN (A.GL_FLAG = 71) THEN A.AMOUNT
								      END AS DEBIT,
								      CASE
										WHEN (A.GL_FLAG = 72) THEN A.AMOUNT
								      END AS CREDIT,
								      A.ID
							     FROM (SELECT * FROM Adjustment_Accounting 
										WHERE CASE
												WHEN ",P_COL_NAME," <> -1 AND ",P_COL_VALUE," <> -1 THEN ",P_COL_NAME," = '",P_COL_VALUE,"'
												WHEN ",P_COL_NAME," = -1 AND ",P_COL_VALUE," = -1 THEN TRUE
												ELSE FALSE
											  END
                                              and
                                              Form_FLAG='",FormFlag,"'
                                              ) A 
								      JOIN ACCOUNTS_ID C ON (A.GL_ACC_ID = C.ID)
						     ORDER BY A.ID) VV
					 GROUP BY ",P_GROUP_BY,";");

    PREPARE STMP FROM @QRY;
    EXECUTE STMP ;
    DEALLOCATE PREPARE STMP;
    
END $$
DELIMITER ;
/*Adjustment_Accounting*/
