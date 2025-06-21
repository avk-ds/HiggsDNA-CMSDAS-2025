# HiggsDNA

A comprehensive analysis framework for Higgs boson physics studies using CMS data.

## 🚀 Quick Start

### Prerequisites

- Python 3.x
- Access to CMS computing environment (recommended: lxplus or similar)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/avk-ds/HiggsDNA-CMSDAS-2025.git
   cd HiggsDNA-CMSDAS-2025
   ```

2. **Run the installation script**
   ```bash
   # Navigate to your desired installation directory (e.g., EOS)
   cd /path/to/your/installation/directory
   
   # Run the installation script
   ./higgs-dna-install.sh
   ```

## 📊 Usage

### Configuration

The analysis uses `runner_systematicsFinalEBEE.json` as the main configuration file for running HiggsDNA.

### Creating Parquet Files

Generate analysis parquet files without job submission:

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
- `--dump`: Output directory for the generated NTuples
- `--executor`: Execution mode (futures for local processing)
- `--triggerGroup`: Trigger selection pattern
- `--nano-version`: NanoAOD version

### Post-Processing: Merge and Convert to ROOT

Convert and merge the parquet files to ROOT format:

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
- `--input`: Input directory containing parquet files
- `--merge`: Merge multiple files
- `--root`: Convert to ROOT format
- `--syst`: Include systematic variations
- `--cats`: Include category information
- `--varDict`: Variable dictionary configuration
- `--catDict`: Category dictionary configuration
- `--skip-normalisation`: Skip normalization step

## 📁 File Structure

```
HiggsDNA-CMSDAS-2025/
├── higgs-dna-install.sh          # Installation script
├── runner_systematicsFinalEBEE.json  # Main analysis configuration
├── run_analysis.py               # Analysis runner script
├── prepare_output_file.py        # Post-processing script
├── var_dict.json               # Variable dictionary
├── eta_cats.json                # Category definitions
└── ...
```

## 🔧 Configuration Files

- **`runner_systematicsFinalEBEE.json`**: Main analysis configuration including systematic variations for ECAL Barrel and Endcap regions
- **`var_dict.json`**: Systematic variations of some variables
- **`eta_cats.json`**: Defines pseudorapidity-based categories
