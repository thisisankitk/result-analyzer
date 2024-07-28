Feature: End of Day Calculations

  Background:
    Given an API key is generated 

  Scenario: Receive test results and calculate daily statistics
    Given we are in the testing month
    And the following test results exist:
      | subject  | timestamp              | marks |
      | Science  | TODAY 12:01:34.678     | 85.25 |
      | Science  | TODAY 13:01:34.678     | 90.50 |
      | Science  | TODAY 14:01:34.678     | 78.00 |
    When the EOD task runs
    Then the daily result stats should be:
      | date  | subject  | daily_low | daily_high | result_count |
      | TODAY | Science  | 78.00     | 90.50      | 3            |

  Scenario: Calculate monthly averages of five days
    Given we are in the testing month
    And the following daily result stats exist:
      | date        | subject  | daily_low | daily_high | result_count |
      | 6_DAYS_AGO  | Science  | 80.00     | 90.00      | 50           |
      | 5_DAYS_AGO  | Science  | 70.00     | 95.00      | 30           |
      | 4_DAYS_AGO  | Science  | 60.00     | 85.00      | 40           |
      | 3_DAYS_AGO  | Science  | 65.00     | 88.00      | 60           |
      | TODAY       | Science  | 78.00     | 90.50      | 22           |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date  | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | TODAY | Science  | 70.60           | 89.70            | 202                       |

  Scenario: Going back in day for minimum data requirement
    Given we are in the testing month
    And the following daily result stats exist:
      | date        | subject  | daily_low | daily_high | result_count |
      | 7_DAYS_AGO  | Science  | 56.50     | 90.00      | 23           |
      | 6_DAYS_AGO  | Science  | 80.00     | 77.50      | 30           |
      | 5_DAYS_AGO  | Science  | 70.00     | 95.00      | 30           |
      | 4_DAYS_AGO  | Science  | 60.00     | 85.00      | 40           |
      | 3_DAYS_AGO  | Science  | 65.00     | 88.00      | 60           |
      | TODAY       | Science  | 78.00     | 90.50      | 22           |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date  | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | TODAY | Science  | 68.25           | 87.67            | 205                       |


  Scenario: Going back in day ultil minimum data availabel
    Given we are in the testing month
    And the following daily result stats exist:
      | date        | subject  | daily_low | daily_high | result_count |
      | 8_DAYS_AGO  | Science  | 56.50     | 90.00      | 23           |
      | 7_DAYS_AGO  | Science  | 56.50     | 90.00      | 23           |
      | 6_DAYS_AGO  | Science  | 80.00     | 77.50      | 30           |
      | 5_DAYS_AGO  | Science  | 70.00     | 95.00      | 30           |
      | 4_DAYS_AGO  | Science  | 60.00     | 85.00      | 40           |
      | 3_DAYS_AGO  | Science  | 65.00     | 88.00      | 60           |
      | TODAY       | Science  | 78.00     | 90.50      | 22           |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date  | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | TODAY | Science  | 68.25           | 87.67            | 205                       |


  Scenario: Going back in days up to max days(30)
    Given we are in the testing month
    And the following daily result stats exist:
      | date        | subject  | daily_low | daily_high | result_count |
      | 32_DAYS_AGO | Science  | 70.00     | 95.00      | 60           |
      | 31_DAYS_AGO | Science  | 60.00     | 85.00      | 50           |
      | 30_DAYS_AGO | Science  | 65.00     | 88.00      | 12           |
      | 29_DAYS_AGO | Science  | 78.00     | 90.50      | 38           |
      | 6_DAYS_AGO  | Science  | 80.00     | 77.50      | 45           |
      | 5_DAYS_AGO  | Science  | 70.00     | 95.00      | 30           |
      | 4_DAYS_AGO  | Science  | 60.00     | 85.00      | 28           |
      | 3_DAYS_AGO  | Science  | 65.00     | 88.00      | 15           |
      | TODAY       | Science  | 78.00     | 90.50      | 10           |
    When the EOD task runs on the Monday of the third Wednesday week
    Then the monthly averages should be:
      | date  | subject  | monthly_avg_low | monthly_avg_high | monthly_result_count_used |
      | TODAY | Science  | 70.86           | 87.79            | 178                       |
