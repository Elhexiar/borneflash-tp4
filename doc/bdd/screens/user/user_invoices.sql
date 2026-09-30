
-- Affiche toutes les factures d'un utilisateur donné.

SELECT 

    personnal.first_name,
    personnal.last_name,
    invoice.code_invoice,
    invoice.date_paid_invoice,
    invoice.amount_energie,
    invoice.tarrif_price_applied,
    invoice.tax_included_cost,
    invoice.tax_amount,
    invoice.tax_excluded_cost,
    invoice.is_paid_invoice,
    invoice.date_emited_invoice
FROM invoice
LEFT JOIN personnal ON personnal.id_user = invoice.id_user
