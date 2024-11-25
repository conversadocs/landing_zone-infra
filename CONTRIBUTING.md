# Contributing

- [Contributing](#contributing)
  - [Project Structure](#project-structure)
    - [Environments](#environments)
    - [Local Port Management](#local-port-management)
  - [Setup](#setup)
    - [Optional Prerequisites](#optional-prerequisites)
    - [Python with pyenv](#python-with-pyenv)
      - [venv](#venv)
    - [Node.js](#nodejs)
      - [pnpm](#pnpm)
    - [pre-commit and commitizen](#pre-commit-and-commitizen)
  - [Code Standards](#code-standards)
    - [Python](#python)
    - [Typescript](#typescript)
    - [Database Standards](#database-standards)
      - [Using ORMs](#using-orms)
    - [Infrastructure as Code (IaC) Standards](#infrastructure-as-code-iac-standards)
      - [General Guidelines](#general-guidelines)
    - [Markup and Data Serialization Standards](#markup-and-data-serialization-standards)
  - [Testing Standards](#testing-standards)
    - [Python Testing Standards](#python-testing-standards)
    - [TypeScript Testing Standards](#typescript-testing-standards)
    - [IaC Testing Standards](#iac-testing-standards)
    - [Integration Testing](#integration-testing)
    - [Performance Testing](#performance-testing)
    - [User Acceptance Testing (UAT)](#user-acceptance-testing-uat)
    - [A/B Testing](#ab-testing)
  - [Version Control Standards](#version-control-standards)
  - [CI/CD Standards](#cicd-standards)
    - [Pipelines Structure](#pipelines-structure)
    - [CI/CD Principles](#cicd-principles)
  - [TL;DR](#tldr)
    - [Project Structure](#project-structure-1)
    - [Setup](#setup-1)
    - [Code Standards](#code-standards-1)
    - [Testing Standards](#testing-standards-1)
    - [Version Control Standards](#version-control-standards-1)
    - [CI/CD Standards](#cicd-standards-1)
  - [Additional Resources](#additional-resources)

## Project Structure

This project follows a consistent structure to ensure clarity and maintainability. Below are the key directories and
files you will encounter:

- **README.md**: Entry point for the project.

  - Includes a brief project description.
  - Instructions for setup, testing, demonstration, etc.

- **CHANGELOG.md**: Changelog managed by Semantic Release.

- **CODE_OF_CONDUCT.md**: This file. Provides guidelines on how to contribute.

- **CONTRIBUTING.md**: This file. Provides guidelines on how to contribute.

- **SECURITY.md**: Security policies governing this project.

- **.config/**: Contains repository configurations.

  - `.config/.adr-dir`: Config file for adr-tools package.
  - `.config/.checkov.yaml`: Configuration file for Checkov security scans.
  - `.config/.pre-commit-config.yaml`: Configuration for pre-commit hooks.
  - `.config/.releaserc.yaml`: Configuration for Semantic Release.

- **.github/**: Contains various GitHub configurations.

  - `.github/ISSUE_TEMPLATE/`: Templates for GitHub issues.
  - `.github/workflows/`: GitHub Actions workflows.
  - `.github/CODEOWNERS`: Specifies code reviewers and maintainers.
  - `.github/pull_request_template`: Template for pull requests.

- **.vscode/**: Configuration files for Visual Studio Code.

  - `.vscode/extensions.json`: Recommended extensions.
  - `.vscode/settings.json`: Workspace settings.

- **documentation/**: Documentation for developers and business stakeholders.

  - `documentation/README.md`: Technical specification guide.
  - `documentation/adrs/`: Architecture Decision Records in markdown format.
  - `documentation/structurizr/`: Structurizr diagrams and website solutions.

- **.gitignore**: Specifies files and directories to be ignored by Git.

- **Makefile**: Set of commands to simplify development and local use.

_Note_: Other configuration files for linting, formatting, or dependency management would reside in the project root
unless otherwise necessary.

### Environments

- **Local**: This is the developer's machine where initial development and testing are done.
- **DEV**: The Development environment which reflects the latest code pushed to the `main` branch. This environment is
  more informal and is often used for integration testing.
- **UAT**: The User Acceptance Testing environment is optional and serves as a more controlled version of DEV. This is
  where stakeholders test new features before they go live.
- **IMPL**: The Implementation environment is also optional and is a temporary setup for validating code deployments. It
  mirrors the production state as closely as possible and supports blue/green deployments.
- **PROD**: The Production environment is the live environment where the application is available to end-users. There
  may be A/B versions of PROD for canary releases or gradual rollouts, but generally, this is the live system.

### Local Port Management

- **UI Ports**: Use 8080, 8081, 8082, etc.
- **Application Service Ports**: Map to the 2000 range.
- **API Service Ports**: Map to the 3000 range.
- **NoSQL Service Ports**: Map to the 4000 range.
- **SQL Service Ports**: Use native ports, e.g., 5432 for PostgreSQL.
- **Extra Support Service Ports**: Start at 10000 (e.g., 10000 reserved for Structurizr).
- **Grouped Services**: Use 100-based port ranges for similar services.
  - Database Tools: Use the 10100 range.
  - Scanning Tools: Use the 10200 range.
- **Multiple Services in Same Range**:
  - Use the base range for the primary service (e.g., 3000).
  - Use increments of 100 for additional services (e.g., 3100, 3200).

_Note_: All services should run via Docker Compose. Alternative approaches like Minikube are acceptable if ports are
arranged correctly.

## Setup

For any contribution to this project there are pre-requisite software and configurations that should be set on your
system.

- **git**: Install instructions for all platforms [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  _Note_: DO NOT use GitHub Desktop unless you ensure your commit messages are compliant with the project standards.

- **Docker**

  - Mac install instructions [here](https://docs.docker.com/desktop/install/mac-install/)
  - Windows install instructions [here](https://docs.docker.com/desktop/install/windows-install/) (it is **_highly_**
    recommended to setup WSL2 _first_ so that Docker can use the native Linux kernel instead of a VM but see
    [WSL2](#wsl2) for more information)
  - Linux (Ubuntu) install instructions [here](https://docs.docker.com/engine/install/ubuntu/) **Note**: if using WSL2
    you must also install _inside_ of the Linux environment, so you would also follow these instructions from your Linux
    `Terminal` in Windows.

- **Homebrew**: Install instructions for Mac or Linux [here](https://brew.sh/)

- **adr-tools**: Install instructions for Mac or Linux [here](https://github.com/npryce/adr-tools)

- **WSL2 (Windows)**: Install instructions for Windows 10 or 11
  [here](https://learn.microsoft.com/en-us/windows/wsl/install)

_Note_: All instructions are for Linux and Mac only. If using WSL2 in Windows run commands in an Ubuntu `Terminal`.

### Optional Prerequisites

- **VS Code**: Recommended code editor for development.
- **Postman**: Useful for API testing and development.
- **DBeaver**: Database management tool for querying and managing databases.

### Python with pyenv

For certain automations and quality-gate tools to work Python must be available to the host OS. With `brew` (Homebrew)
installed it is recommended that Python is managed via `pyenv` on the host machine which is simple to setup using
`brew`. To setup and configure Python on your host machine, even if its already there, follow these steps:

1. run `brew install pyenv`
2. follow the installation instructions to add to `PATH` and to your bash/zsh configuration
3. run `pyenv install 3.10`
4. run `pyenv global 3.10`

#### venv

When working with Python it is best practice to utilize a virtual environment for local dependency management. To do
this follow these steps from the project root:

- run `python -m venv venv`
- run `source venv/bin/activate`
- install any dependencies with `pip install -r requirements.txt`

### Node.js

To run unit tests locally and to take advantage of IDE dependency and path mapping you must have Node.js installed on
the host OS. With `brew` installed it is recommended that Node is managed via `n` on the host machine which is simple to
setup using `brew`. To setup and configure Node on your host machine, even if its already there, follow these steps:

- run `brew install n`
- run `sudo n install latest && sudo n latest`

#### pnpm

This project uses a more robust package management suite called `pnpm`. You must install this locally via `npm` however
after it is installed local service `npm` commands will be replaced with `pnpm`. To install `pnpm` simply follow this
one step:

- run `npm i -g pnpm`

### pre-commit and commitizen

Once `brew` and Python are installed and correctly configured on your machine you need to install `pre-commit`, and
`commitizen` to make use of the local quality gate protections and automation. Follow these steps:

1. run `brew install pre-commit`
2. run `pre-commit install`
3. run `brew install commitizen`

Once both `pre-commit` and `commitizen` are installed you can manually check your commit validity by running

```bash
make pre-commit
```

**_OR_**

```bash
pre-commit run -a
```

You can run `commitizen` on its own by running `cz c`.

_Note_: The `pre-commit` configuration will prevent any git commits from taking place when:

- There is upstream changes that could result in merge conflicts
- The commit message violates [conventional commit standards](#conventional-commits)
- The [OpenAPI](#openapi) specification is invalid
- The code is not formatted correctly or otherwise violates [linting requirements](#linting-and-formatting)
- Any [unit tests](#unit-testing) fail

## Code Standards

To maintain consistency and readability, all contributors must adhere to the following coding standards.

- **General Guidelines**:

  - Write clear and concise code.
  - Use meaningful variable, function, and class names.
  - Keep functions and methods small and focused on a single task.
  - Avoid hardcoding values; use constants, configuration files, or environment variables.
  - Ensure code is well-documented. Use comments sparingly and only to explain complex logic.

- **Formatting**:

  - Follow the language-specific auto-formatting rules.
  - Maintain consistent code indentation; typically 4 spaces for most languages.
  - Use single quotes or double quotes consistently for strings.

- **Error Handling**:

  - Handle errors gracefully, provide meaningful error messages.
  - Avoid using generic exceptions; be as specific as possible.
  - Log errors at appropriate levels (debug, info, warning, error, critical).

- **Best Practices**:
  - Follow DRY (Don't Repeat Yourself) principles.
  - Use version control for all changes.
  - Ensure compatibility with existing systems and libraries.
  - Write unit tests for all new code and ensure existing tests pass.

### Python

- **Formatting**:

  - Use Black for code formatting.
  - Indentation: 4 spaces per indentation level.
  - Max line length: 88 characters (Black default).

- **Linting**:

  - Use flake8 for linting.
  - Configure rules in `setup.cfg` or `tox.ini`.

- **Naming Conventions**:

  - Follow PEP 8 naming conventions:
    - Variables, functions, and methods: `lower_case_with_underscores`
    - Classes and exceptions: `CapWords`
    - Constants: `UPPER_CASE_WITH_UNDERSCORES`

- **Imports**:

  - Group imports in the following order:
    1. Standard library imports
    2. Related third-party imports
    3. Local application/library-specific imports
  - Each group should be separated by a blank line.

- **Error Handling**:

  - Use exception-specific error handling.
  - Avoid bare `except:` clauses; use `except Exception:` at a minimum.

- **Typing**:

  - Use type hints where possible.

  ```python
  def greet(name: str) -> str:
      return f"Hello, {name}"
  ```

- **Comments and Docstrings**:

  - Follow PEP 257 for docstrings.
  - Use triple quotes for docstrings.
  - Use inline comments sparingly and only when necessary.

- **Testing**:
  - Use pytest for testing.
  - Place tests in a `tests/` directory.
  - Write unit tests for new features and bug fixes.

**Example Configuration for `setup.cfg`**:

```ini
[flake8]
max-line-length = 88
exclude = .git,__pycache__,old,build,dist
```

### Typescript

- **Formatting**:

  - Use Prettier for code formatting.
  - No semicolons.
  - No trailing commas.
  - Use single quotes for strings.
  - Tab width of 2 spaces.

- **Linting**:
- Use ESLint for linting.
- Enforce import order and grouping: `builtin`, `external`, `internal`.
- Enforce TSDoc syntax for comments.
- Indent with 2 spaces.
- Use Unix-style linebreaks.
- Disallow `console` statements and unused variables.
- Integrate Prettier with ESLint for formatting rules.

- **Naming Conventions**

  - Variables and functions: `camelCase`
  - Classes and Interfaces: `PascalCase`
  - Constants: `UPPER_CASE_SNAKE_CASE`

- **Imports**:

  - Order imports by groups: `builtin`, `external`, `internal`.
  - No empty lines between import groups.

- **Error Handling**:

  - Use specific error types.
  - Avoid using `any` for error type.

- **Typing**:

  - Use TypeScript types and interfaces.

  ```typescript
  interface User {
    name: string
    age: number
  }

  const greetUser = (user: User): string => {
    return `Hello, ${user.name}`
  }
  ```

- **Comments and Docstrings**:

  - Use TSDoc for comments.
  - Place comments above the relevant code.

  ```typescript
  /**
   * Represents a user in the system.
   * @param name The user's name.
   * @param age The user's age.
   */
  class User {
    name: string
    age: number

    constructor(name: string, age: number) {
      this.name = name
      this.age = age
    }
  }
  ```

- **Testing**:
  - Use Jest for testing.
  - Use test files named similarly to the file being tested.
  - Write unit tests for all functions and components.

### Database Standards

- **General Guidelines**:

  - Use Liquibase for database version control and schema management.
  - Avoid embedding raw SQL directly in the application code.
  - Use ORM libraries like Sequelize (for TypeScript) or SQLAlchemy (for Python) for SQL queries.
  - MongoDB is the preferred NoSQL database, though exceptions can be made for platform-native options like DynamoDB.

- **Liquibase Best Practices**:
  - Use an initial `data/liquibase/db.changelog.xml` file as entrypoint for all changesets.
  - Store all Liquibase changesets in the `data/liquibase/changes` directory.
  - Name changesets with a numerical prefix to keep them in order.
  - Use meaningful IDs and descriptions for changesets.
  - Group related changesets in a single file for easier management.
  - Do not change any already applied changesets. Any changes to existing schema will need a new changeset.
  - Validate changesets before committing to ensure they apply cleanly.
  - Use logicalFilePath to assist in change log context switching.

**Example Liquibase Changeset**

```xml
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.8.xsd">

    <changeSet id="1-create-user-table" author="yourname">
        <createTable tableName="user">
            <column name="id" type="int" autoIncrement="true">
                <constraints primaryKey="true"/>
            </column>
            <column name="username" type="varchar(255)">
                <constraints nullable="false"/>
            </column>
            <column name="email" type="varchar(255)">
                <constraints unique="true" nullable="false"/>
            </column>
        </createTable>
    </changeSet>

</databaseChangeLog>
```

#### Using ORMs

**TypeScript Example with Sequelize**:

```typescript
import { Sequelize, Model, DataTypes } from 'sequelize'

const sequelize = new Sequelize('database', 'username', 'password', {
  host: 'localhost',
  dialect: 'postgres'
})

class User extends Model {
  public id!: number
  public username!: string
  public email!: string
}

User.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    username: {
      type: new DataTypes.STRING(128),
      allowNull: false
    },
    email: {
      type: new DataTypes.STRING(128),
      allowNull: false,
      unique: true
    }
  },
  {
    sequelize,
    tableName: 'users'
  }
)
```

**Python Example with SQLAlchemy**

```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine('sqlite:///example.db')
Session = sessionmaker(bind=engine)
session = Session()
Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String, nullable=False)
    email = Column(String, nullable=False, unique=True)

Base.metadata.create_all(engine)
```

### Infrastructure as Code (IaC) Standards

#### General Guidelines

- Use Terraform for platform infrastructure.
- Kubernetes manifests should be maintained for project deployment and management.
- Serverless Framework can be used for local Lambda development and testing, but deploy via Terraform.

- **Terraform**:

  - Store Terraform code in the `terraform/` directory.
  - Follow HCL formatting and best practices.
  - Group related resources in numbered modules to indicate the order of dependency.
  - Create `provider.tf` files to configure providers.
  - Minimize variables by using `data` and `locals` where applicable.
  - Parameterize everything to ensure maximum reusability.
  - Use `terraform-docs` for documentation.
  - Use `tf-lint` to enforce best practices.

- **Kubernetes**:

  - Store Kubernetes manifests in the `config/kubernetes` directory.
  - Use YAML format.
  - Follow Kubernetes best practices for resource definitions.

- **Serverless Framework**:
  - Use Serverless Framework for local Lambda development.
  - Store Serverless configurations in the `serverless/` directory.
  - Only for local use; deploy via Terraform.

### Markup and Data Serialization Standards

- **General Guidelines**:

  - Use Prettier for formatting.
  - Tab width: 2 spaces for Markdown, YAML, XML, and JSON.

- **Markdown**:
  - Prose wrapping: Always.

## Testing Standards

To ensure quality and stability of our application or project while in active development it is critical testing
standards and practices are followed. They are defined as follows:

- **General Guidelines**:
  - Write unit tests for every new feature and bug fix.
  - Unit test coverage should meet or exceed 80% of all code at all times.
  - Ensure existing tests pass before submitting a pull request.
  - Use clear and descriptive names for test functions.
  - Follow Test-Driven Development (TDD) practices where applicable.

### Python Testing Standards

- Use `pytest` for unit testing.
- Store tests in the `test/` directory.

```python
# tests/test_example.py
def test_sample():
    assert 1 + 1 == 2
```

### TypeScript Testing Standards

- Use `Jest` for unit testing.
- Place test files in the same directory as the files being tested.
- Use the `.spec.ts` or `.test.ts` extension for test files.

```typescript
// tests/example.test.ts
test('adds 1 + 1 to equal 2', () => {
  expect(1 + 1).toBe(2)
})
```

### IaC Testing Standards

- Use `terratest` for testing Terraform code.
- Store tests in the `tests/` directory alongside `terraform/`.

```go
// tests/terraform_test.go
package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {
  options := &terraform.Options{
    TerraformDir: "../terraform/",
  }
  defer terraform.Destroy(t, options)
  terraform.InitAndApply(t, options)
}
```

### Integration Testing

- Use appropriate frameworks based on the language and stack.
- Tests should cover end-to-end scenarios.
- Store integration tests in the `integration_tests/` directory.

```python
# integration_tests/test_api_integration.py
def test_api_end_to_end():
    response = requests.get("http://api.example.com/data")
    assert response.status_code == 200
```

### Performance Testing

- Use `k6`, `Locust`, or equivalent tools.
- Store performance tests in the `performance_tests/` directory.

```javascript
// performance_tests/load_test.js
import http from 'k6/http'

export default function () {
  http.get('http://example.com')
}
```

### User Acceptance Testing (UAT)

- Use frameworks like `Cypress`, `Selenium` or similar.
- Store UAT tests in the `uat_tests/` directory.

```javascript
// uat_tests/user_acceptance_test.js
describe('User Login', () => {
  it('should login successfully', () => {
    cy.visit('/login')
    cy.get('input[name=username]').type('user')
    cy.get('input[name=password]').type('password')
    cy.get('button[type=submit]').click()
    cy.url().should('include', '/dashboard')
  })
})
```

### A/B Testing

- Use platform-specific tools or services.
- Store A/B tests alongside the application code for easy access and management.

```javascript
// ab_tests/feature_flag_test.js
if (featureFlag.isEnabled('new-feature')) {
  // show new feature
} else {
  // show old feature
}
```

## Version Control Standards

To ensure smooth and coordinated distributed workstreams we follow a series of policies and practices for version
control. They are as follows:

- **General Guidelines**:

  - Only use Git for version control.
  - Use GitHub as the origin site.
  - Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
  - The `main` branch is the primary branch.
  - All work should be done in feature branches.

- **Branching**:

  - Feature branches should be labeled using the GitHub issue number and GitHub username: `10-exampleUsername`.
    - If multiple feature branches are needed: `10-exampleUsername-1`.
    - Assisting another effort, create branches off the other feature branch: `10-exampleUsername-anotherUsername`.
  - Forks are allowed but not preferred.
  - For emergency work create a feature branch with the prefix of `HOTFIX` followed by a one to two word description of
    the emergency.

- **Pull Requests (PRs)**:

  - Draft a PR with an initial documentation commit indicating the work being done. Use `Resolves #10` in the footer.
  - PRs must be used to merge feature branches into `main`.
  - Use the PR template with checkboxes for tests and documentation updates. If not applicable, note it in PR comments.
  - Supplement feature branches should be merged back using a PR.

- **Merging**:

  - Use squash and merge when merging into `main`.
  - Don't rebase.
  - Use `--no-ff` when merging `main` into a feature branch to keep history clear.
  - Ensure stashed changes are cleared before committing.

- **Versioning**:
  - Automation creates tags on merges using Conventional Commits for [semantic versioning](https://semver.org/).
  - Prefer linear progression through versions (`v1` to `v2`) on `main`.
  - If needed, maintain different MAJOR release tracks by creating a new branch (e.g., `v1`) before starting new work on
    `main`.

## CI/CD Standards

Projects should include pipelines for testing, compliance, security, etc., leveraging GitHub Actions.

### Pipelines Structure

- **Quality-Gate Pipelines**: Must include unit testing, linting/formatting checks (e.g., API spec linting), and simple
  security scanning (e.g., Checkov).
- **Release Pipelines**: Perform semantic release and tag a Git branch. Tags/releases Docker images, npm/pip, etc., with
  `latest` and semver tags.
- **Deploy Pipelines**: Automatically release new tags to DEV (and possibly UAT) environments, but with a manual deploy
  option or separate config for higher environments (IMPL/PROD).
- **Performance Pipelines**: Run performance tests, can be automated or manual.
- **Security Pipelines**: Periodically check for dependency or config updates.
- **Integration Pipelines**: May run before or after deploy pipelines.

### CI/CD Principles

- **Consolidation**: Group pipelines logically to minimize redundancy.
- **Restricted Actions**: Releasing code, deploying code, or performance testing should be pipeline-restricted.
- **Schema Management**: Liquibase updates must build SQL changes pushed to a protected `sql` branch during release.
  Lower environments (DEV) will run Liquibase directly; higher environments (IMPL/PROD) will apply SQL after peer
  review.

## TL;DR

### Project Structure

Consistent project structure with key directories:

- **README.md**: Project intro, setup, testing.
- **CHANGELOG.md**: Semantic Release changelog.
- **CODE_OF_CONDUCT.md**: Contribution guidelines.
- **CONTRIBUTING.md**: Contribution guidelines.
- **SECURITY.md**: Security policies.
- **.github/**: GitHub configs.
- **.vscode/**: VS Code settings.
- **documentation/**: Developer and stakeholder docs.
- **.adr-dir**: adr-tools config.
- **.checkov.yaml**: Checkov config.
- **.gitignore**: Gitignore rules.
- **.pre-commit-config.yaml**: Pre-commit hooks.
- **.releaserc.yaml**: Semantic Release config.
- **Makefile**: Dev and local use commands.

**Environments**:

- Local: Developer's machine.
- DEV: Latest `main` code.
- UAT: Stakeholder testing.
- IMPL: Temp deployment validation.
- PROD: Live environment.

**Local Port Management**:

- UI: 8080+
- App Services: 2000+
- API: 3000+
- NoSQL: 4000+
- SQL: Native ports.
- Support Services: 10000+
- Grouped: 10100 for DB tools, 10200 for scanning.

Services via Docker Compose. Alternative: Minikube if ports align.

### Setup

- **Pre-requisite Software and Configuration**:

  - **git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - **Note**: Avoid GitHub Desktop unless commit messages meet project standards.
  - **Docker**:

    - [Mac](https://docs.docker.com/desktop/install/mac-install/)
    - [Windows](https://docs.docker.com/desktop/install/windows-install/) (Recommended: Setup WSL2 first)
    - [Linux (Ubuntu)](https://docs.docker.com/engine/install/ubuntu/) (For WSL2, follow instructions inside Ubuntu
      `Terminal`)

  - **Homebrew**: [Install Homebrew](https://brew.sh/)
  - **adr-tools**: [Install adr-tools](https://github.com/npryce/adr-tools)
  - **WSL2 (Windows)**: [Install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
    - **Note**: Instructions are for Linux and Mac only; for WSL2, use Ubuntu `Terminal`.

- **Optional**:

  - **VS Code**: Recommended code editor.
  - **Postman**: API testing tool.
  - **DBeaver**: Database management tool.

- **Python with pyenv**:

  1. `brew install pyenv`
  2. Add to `PATH` and update bash/zsh configuration.
  3. `pyenv install 3.10`
  4. `pyenv global 3.10`

  - **venv**:
    1. `python -m venv venv`
    2. `source venv/bin/activate`
    3. `pip install -r requirements.txt`

- **Node.js with n**:

  1. `brew install n`
  2. `sudo n install latest && sudo n latest`

  - **pnpm**:
    1. `npm i -g pnpm`

- **pre-commit and commitizen**:
  1. `brew install pre-commit`
  2. `pre-commit install`
  3. `brew install commitizen`

To manually check commit validity:

- Run `cz c` for `commitizen`.

**Note**: `pre-commit` prevents commits if:

- There are merge conflicts.
- Commit message violates standards.
- OpenAPI spec is invalid.
- Code violates linting requirements.
- Any unit tests fail.

### Code Standards

- **General Guidelines**:
  - Write clear and concise code.
  - Use meaningful variable, function, and class names.
  - Keep functions and methods small and focused on a single task.
  - Avoid hardcoding values; use constants, configuration files, or environment variables.
  - Ensure code is well-documented. Use comments sparingly and only to explain complex logic.
- **Formatting**:
  - Follow language-specific auto-formatting rules.
  - Maintain consistent code indentation; typically 4 spaces.
  - Use single quotes or double quotes consistently for strings.
- **Error Handling**:
  - Handle errors gracefully, provide meaningful error messages.
  - Avoid using generic exceptions; be as specific as possible.
  - Log errors at appropriate levels (debug, info, warning, error, critical).
- **Best Practices**:
  - Follow DRY (Don't Repeat Yourself) principles.
  - Use version control for all changes.
  - Ensure compatibility with existing systems and libraries.
  - Write unit tests for all new code and ensure existing tests pass.
- **Python**:
  - **Formatting**:
    - Use Black for code formatting.
    - Indentation: 4 spaces per level.
    - Max line length: 88 characters (Black default).
  - **Linting**:
    - Use flake8 for linting.
    - Configure rules in `setup.cfg` or `tox.ini`.
  - **Naming Conventions**:
    - Follow PEP 8:
      - Variables, functions, methods: `lower_case_with_underscores`
      - Classes, exceptions: `CapWords`
      - Constants: `UPPER_CASE_WITH_UNDERSCORES`
  - **Imports**:
    - Group by:
      1. Standard library imports
      2. Related third-party imports
      3. Local application/library-specific imports
    - Use blank lines to separate groups.
  - **Error Handling**:
    - Use exception-specific error handling.
    - Avoid bare `except:` clauses; use `except Exception:` at a minimum.
  - **Typing**:
    - Use type hints where possible.
  - **Comments and Docstrings**:
    - Follow PEP 257 for docstrings.
    - Use triple quotes for docstrings.
    - Use inline comments sparingly and when necessary.
  - **Testing**:
    - Use pytest for testing.
    - Place tests in a `tests/` directory.
    - Write unit tests for new features and bug fixes.
- **Typescript**:
  - **Formatting**:
    - Use Prettier for code formatting.
    - No semicolons.
    - No trailing commas.
    - Use single quotes for strings.
    - Tab width: 2 spaces.
  - **Linting**:
    - Use ESLint for linting.
    - Enforce import order and grouping: `builtin`, `external`, `internal`.
    - Enforce TSDoc syntax for comments.
    - Indent with 2 spaces.
    - Use Unix-style linebreaks.
    - Disallow `console` statements and unused variables.
    - Integrate Prettier with ESLint for formatting rules.
  - **Naming Conventions**:
    - Variables, functions: `camelCase`
    - Classes, Interfaces: `PascalCase`
    - Constants: `UPPER_CASE_SNAKE_CASE`
  - **Imports**:
    - Order imports: `builtin`, `external`, `internal`.
    - No empty lines between import groups.
  - **Error Handling**:
    - Use specific error types.
    - Avoid using `any` for error type.
  - **Typing**:
    - Use TypeScript types and interfaces.
  - **Comments and Docstrings**:
    - Use TSDoc for comments.
    - Place comments above relevant code.
  - **Testing**:
    - Use Jest for testing.
    - Use test files named similarly to the file being tested.
    - Write unit tests for all functions and components.
- **Database Standards**:
  - General Guidelines:
    - Use Liquibase for database version control and schema management.
    - Avoid embedding raw SQL directly in the application code.
    - Use ORM libraries like Sequelize (TypeScript) or SQLAlchemy (Python) for SQL queries.
    - Prefer MongoDB for NoSQL, though exceptions like DynamoDB are acceptable.
  - **Liquibase Best Practices**:
    - Use an initial `data/liquibase/db.changelog.xml` file as entry point for all changesets.
    - Store Liquibase changesets in `data/liquibase/changes`.
    - Name changesets with a numerical prefix for order.
    - Use meaningful IDs and descriptions for changesets.
    - Group related changesets in a single file.
    - Do not change already applied changesets; use a new changeset for schema changes.
    - Validate changesets before committing.
    - Use logicalFilePath for change log context switching.
- **Infrastructure as Code**:
  - General Guidelines:
    - Use Terraform for platform infrastructure.
    - Maintain Kubernetes manifests for project deployment and management.
    - Serverless Framework for local Lambda development and testing; deploy via Terraform.
  - **Terraform**:
    - Store Terraform code in `terraform/`.
    - Follow HCL formatting and best practices.
    - Group related resources in numbered modules.
    - Create `provider.tf` files for provider configurations.
    - Minimize variables; use `data` and `locals`.
    - Parameterize everything for reusability.
    - Use `terraform-docs` for documentation.
    - Use `tf-lint` to enforce best practices.
  - **Kubernetes**:
    - Store Kubernetes manifests in `config/kubernetes`.
    - Use YAML format.
    - Follow best practices for resource definitions.
  - **Serverless Framework**:
    - Store Serverless configurations in `serverless/`.
    - Only for local use; deploy via Terraform.
- **Markup and Data Serialization Standards**:
  - General Guidelines:
    - Use Prettier for formatting.
    - Tab width: 2 spaces for Markdown, YAML, XML, and JSON.
  - **Markdown**:
    - Prose wrapping: Always.

### Testing Standards

- **General Guidelines**:

  - Write unit tests for every new feature and bug fix.
  - Unit test coverage should meet or exceed 80%.
  - Ensure existing tests pass before submitting a pull request.
  - Use clear and descriptive names for test functions.
  - Follow TDD practices where applicable.

- **Python Testing Standards**:

  - Use `pytest` for unit testing.
  - Store tests in the `test/` directory.

- **TypeScript Testing Standards**:

  - Use `Jest` for unit testing.
  - Place test files in the same directory as the files being tested.
  - Use `.spec.ts` or `.test.ts` extension for test files.

- **IaC Testing Standards**:

  - Use `terratest` for testing Terraform code.
  - Store tests in the `tests/` directory alongside `terraform/`.

- **Integration Testing**:

  - Use appropriate frameworks based on the language and stack.
  - Tests should cover end-to-end scenarios.
  - Store integration tests in the `integration_tests/` directory.

- **Performance Testing**:

  - Use `k6`, `Locust`, or equivalent tools.
  - Store performance tests in the `performance_tests/` directory.

- **UAT**:

  - Use frameworks like `Cypress`, `Selenium`, or similar.
  - Store UAT tests in the `uat_tests/` directory.

- **A/B Testing**:
  - Use platform-specific tools or services.
  - Store A/B tests alongside the application code.

### Version Control Standards

- **General Guidelines**:

  - Only use Git for version control.
  - Use GitHub as the origin site.
  - Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
  - The `main` branch is the primary branch.
  - All work should be done in feature branches.

- **Branching**:

  - Feature branches should be labeled using the GitHub issue number and GitHub username: `10-exampleUsername`.
    - If multiple feature branches are needed: `10-exampleUsername-1`.
    - Assisting another effort, create branches off the other feature branch: `10-exampleUsername-anotherUsername`.
  - Forks are allowed but not preferred.
  - Use `HOTFIX` branches for emergency work.

- **Pull Requests (PRs)**:

  - Draft a PR with an initial documentation commit indicating the work being done. Use `Resolves #10` in the footer.
  - PRs must be used to merge feature branches into `main`.
  - Use the PR template with checkboxes for tests and documentation updates. If not applicable, note it in PR comments.
  - Supplement feature branches should be merged back using a PR.

- **Merging**:

  - Use squash and merge when merging into `main`.
  - Don't rebase.
  - Use `--no-ff` when merging `main` into a feature branch to keep history clear.
  - Ensure stashed changes are cleared before committing.

- **Versioning**:
  - Automation creates tags on merges using Conventional Commits for [semantic versioning](https://semver.org/).
  - Prefer linear progression through versions (`v1` to `v2`) on `main`.
  - If needed, maintain different MAJOR release tracks by creating a new branch (e.g., `v1`) before starting new work on
    `main`.

### CI/CD Standards

- **Pipelines Structure**:

  - Quality-Gate Pipelines: Must include unit testing, linting/formatting checks (e.g., API spec linting), and simple
    security scanning (e.g., Checkov).
  - Release Pipelines: Perform semantic release and tag a Git branch. Tags/releases Docker images, npm/pip, etc., with
    `latest` and semver tags.
  - Deploy Pipelines: Automatically release new tags to DEV (and possibly UAT) environments, but with a manual deploy
    option or separate config for higher environments (IMPL/PROD).
  - Performance Pipelines: Run performance tests, can be automated or manual.
  - Security Pipelines: Periodically check for dependency or config updates.
  - Integration Pipelines: May run before or after deploy pipelines.

- **CI/CD Principles**:
  - Consolidation: Group pipelines logically to minimize redundancy.
  - Restricted Actions: Releasing code, deploying code, or performance testing should be pipeline-restricted.
  - Schema Management: Liquibase updates must build SQL changes pushed to a protected `sql` branch during release. Lower
    environments (DEV) will run Liquibase directly; higher environments (IMPL/PROD) will apply SQL after peer review.

## Additional Resources

For more information and detailed instructions on specific topics, refer to the following resources:

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): Guidelines for commit messages.
- [Semantic Versioning](https://semver.org/): Versioning standards.
- [PEP 8](https://www.python.org/dev/peps/pep-0008/): Python code style guide.
- [PEP 257](https://www.python.org/dev/peps/pep-0257/): Python docstring conventions.
- [TSDoc](https://tsdoc.org/): TypeScript documentation comments.
- [Black](https://black.readthedocs.io/): Python code formatter.
- [Prettier](https://prettier.io/): Code formatter for various languages.
- [Liquibase](https://www.liquibase.org/): Database schema change management.
- [Terraform](https://www.terraform.io/): Infrastructure as code tool.
- [Serverless Framework](https://www.serverless.com/): Tools for building serverless applications.
- [pytest](https://pytest.org/): Python testing framework.
- [Jest](https://jestjs.io/): JavaScript testing framework.
- [Cypress](https://www.cypress.io/): End-to-end testing framework.
- [k6](https://k6.io/): Performance testing tool.
- [Docker](https://www.docker.com/): Container platform.
- [Homebrew](https://brew.sh/): Package manager for macOS.
- [adr-tools](https://github.com/npryce/adr-tools): Tools for managing Architecture Decision Records.
- [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install): Windows Subsystem for Linux.
