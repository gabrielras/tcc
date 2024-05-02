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
}

#[derive(BorshSerialize, BorshDeserialize, Debug)]
pub enum Instruction {
    AddCredential {
        id: String,
        name: String,
        institution_id: String,
        author: String,
        metadata: String,
    },
    EditCredential {
        id: String,
        name: String,
        institution_id: String,
        author: String,
        metadata: String,
    },
    RemoveCredential {
        id: String,
    },
}

entrypoint!(process_credentials_instruction);

fn process_credentials_instruction(
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
        Instruction::AddCredential { id, name, institution_id, author, metadata } => {
            let new_credential = Credential { id, name, institution_id, author, metadata };
            let mut new_credentials = credentials.clone();
            new_credentials.push(new_credential);
            update_credentials_account(&mut credentials_account.data.borrow_mut(), &new_credentials)?;
        }
        Instruction::EditCredential { id, name, institution_id, author, metadata } => {
            let mut new_credentials = credentials.clone();
            for cred in new_credentials.iter_mut() {
                if cred.id == id {
                    cred.name = name.clone();
                    cred.institution_id = institution_id.clone();
                    cred.author = author.clone();
                    cred.metadata = metadata.clone();
                    break;
                }
            }
            update_credentials_account(&mut credentials_account.data.borrow_mut(), &new_credentials)?;
        }
        Instruction::RemoveCredential { id } => {
            let new_credentials: Vec<Credential> = credentials.into_iter().filter(|cred| cred.id != id).collect();
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
