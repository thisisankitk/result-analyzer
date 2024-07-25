Feature: End of Day Calculations

  Background:                     
    Given an API key is generated 

  Scenario: Receive test results and calculate daily statistics
    Given the following test results exist:
      | subject  | timestamp             | marks |
      | Science  | 2024-07-23 12:01:34.678 | 85.25 |
      | Science  | 2024-07-23 13:01:34.678 | 90.50 |
      | Science  | 2024-07-23 14:01:34.678 | 78.00 |
    When the EOD task runs
    Then the daily result stats should be:
      | date       | subject  | daily_low | daily_high | result_count |
      | 2024-07-23 | Science  | 78.00     | 90.50      | 3            |

  Scenario: Calculate monthly averages on the correct day
    Given the following daily result stats exist:
      | date       | subject  | daily_low | daily_high | result_count |
      | 2024-07-19 | Science  | 80.00     | 90.00      | 50           |
      | 2024-07-20 | Science  | 70.00     | 95.00      | 30           |
      | 2024-07-21 | Science  | 60.00     | 85.00      | 40           |
      | 2024-07-22 | Science  | 65.00     | 88.00      | 60           |
      | 2024-07-23 | Science  | 78.00     | 90.50      | 3            |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date       | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | 2024-07-23 | Science  | 70.60           | 89.30            | 183                       |

  Scenario: Ensure max days back limit works correctly
    Given the following daily result stats exist:
      | date       | subject  | daily_low | daily_high | result_count |
      | 2024-06-20 | Science  | 80.00     | 90.00      | 50           |
      | 2024-06-21 | Science  | 70.00     | 95.00      | 30           |
      | 2024-06-22 | Science  | 60.00     | 85.00      | 40           |
      | 2024-06-23 | Science  | 65.00     | 88.00      | 60           |
      | 2024-06-24 | Science  | 78.00     | 90.50      | 3            |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date       | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | 2024-07-23 | Science  | 70.60           | 89.30            | 183                       |
