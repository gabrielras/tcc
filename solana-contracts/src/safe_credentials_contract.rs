use borsh::{BorshDeserialize, BorshSerialize};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
};

#[derive(Clone, BorshSerialize, BorshDeserialize, Debug)]
pub struct Credential {
    id: String,
    name: String,
    institution_id: String,
    author: String,
    metadata: String,
    event_id: String,
}

#[derive(BorshSerialize, BorshDeserialize, Debug)]
pub enum Instruction {
    AddCredentials {
        ids: Vec<String>,
        names: Vec<String>,
        institution_ids: Vec<String>,
        authors: Vec<String>,
        metadata: Vec<String>,
        event_ids: Vec<String>,
    },
    EditCredentials {
        ids: Vec<String>,
        names: Vec<String>,
        institution_ids: Vec<String>,
        authors: Vec<String>,
        metadata: Vec<String>,
        event_ids: Vec<String>,
    },
    RemoveCredentials {
        ids: Vec<String>,
    },
}

entrypoint!(process_safe_credentials_instruction);

fn process_safe_credentials_instruction(
    _program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    msg!("Processing instruction");

    let accounts_iter = &mut accounts.iter();
    let credentials_account = next_account_info(accounts_iter)?;

    if !credentials_account.is_writable {
        return Err(ProgramError::InvalidArgument);
    }

    if credentials_account.data_len() < 1 {
        return Err(ProgramError::InvalidArgument);
    }

    let credentials: Vec<Credential> = match Credential::try_from_slice(&credentials_account.data.borrow()) {
        Ok(credentials) => vec![credentials],
        Err(_) => return Err(ProgramError::InvalidArgument),
    };

    let instruction: Instruction = match Instruction::try_from_slice(instruction_data) {
        Ok(instruction) => instruction,
        Err(_) => return Err(ProgramError::InvalidArgument),
    };

    match instruction {
        Instruction::AddCredentials { ids, names, institution_ids, authors, metadata, event_ids } => {
            let mut new_credentials = credentials.clone();
            for i in 0..ids.len() {
                let new_credential = Credential {
                    id: ids[i].clone(),
                    name: names[i].clone(),
                    institution_id: institution_ids[i].clone(),
                    author: authors[i].clone(),
                    metadata: metadata[i].clone(),
                    event_id: event_ids[i].clone(),
                };
                new_credentials.push(new_credential);
            }
            update_credentials_account(&mut credentials_account.data.borrow_mut(), &new_credentials)?;
        }
        Instruction::EditCredentials { ids, names, institution_ids, authors, metadata, event_ids } => {
            let mut new_credentials = credentials.clone();
            for i in 0..ids.len() {
                for cred in new_credentials.iter_mut() {
                    if cred.id == ids[i] {
                        cred.name = names[i].clone();
                        cred.institution_id = institution_ids[i].clone();
                        cred.author = authors[i].clone();
                        cred.metadata = metadata[i].clone();
                        cred.event_id = event_ids[i].clone();
                        break;
                    }
                }
            }
            update_credentials_account(&mut credentials_account.data.borrow_mut(), &new_credentials)?;
        }
        Instruction::RemoveCredentials { ids } => {
            let new_credentials: Vec<Credential> = credentials.into_iter().filter(|cred| !ids.contains(&cred.id)).collect();
            update_credentials_account(&mut credentials_account.data.borrow_mut(), &new_credentials)?;
        }
    }

    Ok(())
}

fn update_credentials_account(data: &mut [u8], new_credentials: &[Credential]) -> ProgramResult {
    let serialized_credentials = new_credentials.try_to_vec().unwrap_or_default();
    data[..serialized_credentials.len()].copy_from_slice(&serialized_credentials);
    Ok(())
}
