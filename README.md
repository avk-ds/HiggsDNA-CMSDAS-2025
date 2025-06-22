# HiggsDNA CMSDAS 2025

A framework for Higgs boson analysis.


## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/avk-ds/HiggsDNA-CMSDAS-2025
cd HiggsDNA-CMSDAS-2025
```

### 2. Install Micromamba

Install micromamba on EOS using the following command:

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```

**EOS Paths:**
- Please mention the paths explicitly otherwise by deafult afs space would be used

### 3. Set Up HiggsDNA Environment

Make the installation script executable and run it:

```bash
chmod +x higgs-dna-installation
./higgs-dna-installation
```

When prompted, press **`n`** to proceed.

**If the installation fails**, manually create the environment:

```bash
micromamba env create -f environment.yml
```

### 4. Verify Installation

To check if everything is working correctly:

```bash
./higgs-dna-installation
```

When prompted, press **`d`** to verify the installation.

## Usage

### Configuration

The analysis uses the `runner_systematicsFinalEBEE.json` configuration file for running HiggsDNA.

### Creating Parquet Files

Run the analysis to create Parquet files (without job submission):

```bash
python <path_to_the_file>/run_analysis.py \
    --json-analysis runner_systematicsFinalEBEE.json \
    --dump <path-to-dump>/NTuples \
    --executor futures \
    --triggerGroup .*DoubleEG.* \
    --nano-version 13
```

**Parameters:**
- `--json-analysis`: Configuration file for the analysis
- `--dump`: Output directory for NTuples
- `--executor futures`: Use futures executor for parallel processing
- `--triggerGroup`: Regex pattern for trigger selection (DoubleEG triggers)
- `--nano-version`: NanoAOD version to use

### Merge and Convert to ROOT

Convert the Parquet files to ROOT format and merge them:

```bash
python3 <path_to_post_processing_folder>/prepare_output_file.py \
    --input NTuples_jobsFinal/ \
    --merge \
    --root \
    --syst \
    --cats \
    --varDict var_dict.json \
    --catDict eta_cats.json \
    --skip-normalisation
```

**Parameters:**
- `--input`: Input directory containing Parquet files
- `--merge`: Merge multiple files
- `--root`: Convert to ROOT format
- `--syst`: Include systematic variations
- `--cats`: Include category information
- `--varDict`: Variable dictionary file
- `--catDict`: Category dictionary file
- `--skip-normalisation`: Skip the normalisation step

## File Structure

```
HiggsDNA-CMSDAS-2025/
├── higgs-dna-installation          # Installation script
├── environment.yml                 # Conda environment file
├── runner_systematicsFinalEBEE.json # Analysis configuration
├── var_dict.json                   # Variable dictionary
├── eta_cats.json                   # Category dictionary
├── run_analysis.py                 # Main analysis script
└── prepare_output_file.py          # Post-processing script
```

## Troubleshooting

### Installation Issues

1. **Micromamba installation fails**: Ensure you have internet access and proper permissions on EOS
2. **Environment creation fails**: Check that the `environment.yml` file is present and valid
3. **Script permissions**: Use `chmod +x higgs-dna-installation` to make the script executable
