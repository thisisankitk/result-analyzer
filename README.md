# Result Analyzer Rails App

## Overview

This application works with test results and performs End of Day (EOD) and Monthly Calculations.

### Features

- Receive result data from a third-party service
- Store test results
- Perform daily calculations at 6 PM
- Perform monthly average calculations on the Monday of the week of the third Wednesday
- API authentication using API keys
- Admin panel to show and search records
- Download reports in CSV format

## Getting Started

### Prerequisites

- Ruby 2.7.1 or later
- Rails 6.1.0 or later
- PostgreSQL (recommended) or SQLite3

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/result_analyzer.git
    cd result_analyzer
    ```

2. **Install the dependencies:**

    ```bash
    bundle install
    ```

3. **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Seed the database with an admin user:**

    ```bash
    rails db:seed
    ```

5. **Set up logging for Rake tasks:**

    Add the following code to `config/initializers/rake_logger.rb`:

    ```ruby
    require 'logger'

    module Rake
      class Task
        def logger
          @logger ||= Logger.new(STDOUT)
        end
      end
    end
    ```

6. **Start the Rails server:**

    ```bash
    rails server
    ```

### Running the Application

Navigate to `http://localhost:3000` to access the application.

### API Endpoints

- **POST `/api/v1/results_data`**

  This endpoint receives test result data. Requires an API key for authentication.

  Example JSON payload:
  ```json
  {
    "subject": "Science",
    "timestamp": "2022-04-18 12:01:34.678",
    "marks": 85.25
  }
  ```

### Admin Panel

Navigate to `http://localhost:3000/admin` to access the admin panel.

- **Admin Login:**
  - Email: `admin@example.com`
  - Password: `password`

### Admin Panel Features

- View, create, edit, and delete test results
- View, create, edit, and delete daily result stats
- View, create, edit, and delete monthly averages
- Download results in CSV format

### Background Tasks

- **End of Day Calculations:**
  - Aggregates daily results and calculates statistics at 6 PM.
  - Run manually: `rake eod:calculate`

- **Monthly Average Calculations:**
  - Calculates monthly averages on the Monday of the week of the third Wednesday.
  - Integrated within the EOD task.

### Running Tests

1. **Run RSpec tests:**

    ```bash
    bundle exec rspec
    ```

2. **Run Cucumber tests:**

    ```bash
    bundle exec cucumber
    ```

### Additional Configuration

- **Generate API Key:**

  To generate an API key for a third-party service, run the following Rake task:

  ```bash
  rake api_key:generate
  ```

  The generated API key will be displayed in the console.

### Database Seeding

Add a seed file to create an admin user. Create or update `db/seeds.rb`:

```ruby
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
```



## Max Day Back Logic

The logic ensures that the system does not go back more than 30 days from the current date to collect data for monthly averages. This prevents infinite loops and ensures performance efficiency.

### Example

#### Daily Result Stats

Given today is "2022-04-18" and we receive the following result data for the subject "Science":

```json
[
  {"subject": "Science", "timestamp": "2022-04-18 12:02:44.678", "marks": 123.54},
  {"subject": "Science", "timestamp": "2022-04-18 13:37:26.678", "marks": 120.99},
  {"subject": "Science", "timestamp": "2022-04-18 15:33:23.678", "marks": 126.76},
  {"subject": "Science", "timestamp": "2022-04-18 17:21:55.678", "marks": 119.88},
  {"subject": "Science", "timestamp": "2022-04-18 17:47:27.678", "marks": 125.21}
]
```
The system will calculate today's daily result stats for the subject "Science" as:
```table
   date		subject	daily_low	daily_high	result_count
2022-04-18	Science	 119.88		  126.76		5
```
Monthly Averages
Given today is "2022-04-18" and the system has the following Daily Result Stats:

```table
date 			 subject	 daily_low	daily_high	result_count
2022-04-07		 Science	 119.88		 126.76			18
2022-04-08		 Science	 123.73		 127.23			11
2022-04-11		 Science	 121.12		 124.52			12
2022-04-12		 Science	 117.22		 120.11			81
2022-04-13		 Science	 118.84		 119.29			22
2022-04-14		 Science	 120.27		 123.33			57
2022-04-15		 Science	 126.01		 128.77			23
2022-04-18		 Science	 124.30		 125.58			12
```
The system should go backward in days from today (18th), collecting result stats data for a minimum of 5 days (from 18th to 12th). If the total result count is less than 200, it will go back one day at a time until it reaches at least 200 results, but it will not go back more than 30 days from the current date.


### Contributing

Feel free to submit issues, fork the repository and send pull requests!

### License

This project is licensed under the MIT License.

With this README, anyone should be able to set up the application on their local machine, understand its features, and know the URLs to navigate. It also includes instructions for generating API keys, accessing the admin panel, and running tests.
```