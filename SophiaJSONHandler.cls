//
// This class contains the Inner classes and methods needed to parse through and create objects for the complex JSON returned
// specifically by the "Get student report for specific course" endpoint (https://api.sophia.org/api/v1.1/courses/[:course_id]/student_by_external_id/[:student_id]/report)

public class SophiaJSONHandler {
	
	public Integer response_code {get;set;} 
	public Data data {get;set;} 

	public SophiaJSONHandler(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'response_code') {
						response_code = parser.getIntegerValue();
					} else if (text == 'data') {
						data = new Data(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SophiaJSONHandler consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Activity {
		public String state {get;set;} 
		public Date start_date {get;set;} 
		public Date end_date {get;set;} 
		public Integer total_time {get;set;} 
		public Date last_activity_date {get;set;} 
		public Integer days_remaining {get;set;} 
		public Date course_registration_date {get;set;} 
		public Integer tutorial_views {get;set;} 
		public Date engaged_date {get;set;} 

		public Activity(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'state') {
							state = parser.getText();
						} else if (text == 'start_date') {
							start_date = parser.getDateValue();
						} else if (text == 'end_date') {
							end_date = parser.getDateValue();
						} else if (text == 'total_time') {
							total_time = parser.getIntegerValue();
						} else if (text == 'last_activity_date') {
							last_activity_date = parser.getDateValue();
						} else if (text == 'days_remaining') {
							days_remaining = parser.getIntegerValue();
						} else if (text == 'course_registration_date') {
							course_registration_date = parser.getDateValue();
						} else if (text == 'tutorial_views') {
							tutorial_views = parser.getIntegerValue();
						} else if (text == 'engaged_date') {
							engaged_date = parser.getDateValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Activity consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Courses {
		public String id {get;set;} 
		public String title {get;set;} 
		public Activity activity {get;set;} 
		public List<Units> units {get;set;} 
		public Overview overview {get;set;} 

		public Courses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'title') {
							title = parser.getText();
						} else if (text == 'activity') {
							activity = new Activity(parser);
						} else if (text == 'units') {
							units = arrayOfUnits(parser);
						} else if (text == 'overview') {
							overview = new Overview(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Courses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Items {
		public Integer total_questions {get;set;} 
		public Integer attempted {get;set;} 
		public Integer correct {get;set;} 
		public Integer incorrect {get;set;} 
		public Integer pts_earned {get;set;} 
		public String type {get;set;}
		public String started_at {get;set;} 

		public Items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'total_questions') {
							total_questions = parser.getIntegerValue();
						} else if (text == 'attempted') {
							attempted = parser.getIntegerValue();
						} else if (text == 'correct') {
							correct = parser.getIntegerValue();
						} else if (text == 'incorrect') {
							incorrect = parser.getIntegerValue();
						} else if (text == 'pts_earned') {
							pts_earned = parser.getIntegerValue();
						} else if (text == 'type') {
							type = parser.getText();
						} else if (text == 'started_at') {
							started_at = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Overview {
		public Integer total_points {get;set;} 
		public Double score {get;set;} 
		public Double best_possibble_score {get;set;} 
		public Integer total_challenges {get;set;} 
		public Integer total_milestones {get;set;} 
		public Integer total_touchstones {get;set;} 
		public Integer total_milestones_number {get;set;} 
		public Integer challenges_completed {get;set;} 
		public Integer milestones_completed {get;set;} 
		public Integer challenge_pts_earned {get;set;} 
		public Integer challenge_pts_still_available {get;set;} 
		public Integer challenges_failed {get;set;} 
		public Integer milestone_pts_earned {get;set;} 
		public Integer milestone_pts_still_available {get;set;} 
		public Integer milestones_failed {get;set;} 
		public Integer touchstone_pts_earned {get;set;} 
		public Integer touchstone_pts_still_available {get;set;} 
		public Integer touchstone_failed {get;set;} 
		public Integer final_mls_pts_earned {get;set;} 
		public Double avg_milestones_score {get;set;} 

		public Overview(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'total_points') {
							total_points = parser.getIntegerValue();
						} else if (text == 'score') {
							score = parser.getDoubleValue();
						} else if (text == 'best_possibble_score') {
							best_possibble_score = parser.getDoubleValue();
						} else if (text == 'total_challenges') {
							total_challenges = parser.getIntegerValue();
						} else if (text == 'total_milestones') {
							total_milestones = parser.getIntegerValue();
						} else if (text == 'total_touchstones') {
							total_touchstones = parser.getIntegerValue();
						} else if (text == 'total_milestones_number') {
							total_milestones_number = parser.getIntegerValue();
						} else if (text == 'challenges_completed') {
							challenges_completed = parser.getIntegerValue();
						} else if (text == 'milestones_completed') {
							milestones_completed = parser.getIntegerValue();
						} else if (text == 'challenge_pts_earned') {
							challenge_pts_earned = parser.getIntegerValue();
						} else if (text == 'challenge_pts_still_available') {
							challenge_pts_still_available = parser.getIntegerValue();
						} else if (text == 'challenges_failed') {
							challenges_failed = parser.getIntegerValue();
						} else if (text == 'milestone_pts_earned') {
							milestone_pts_earned = parser.getIntegerValue();
						} else if (text == 'milestone_pts_still_available') {
							milestone_pts_still_available = parser.getIntegerValue();
						} else if (text == 'milestones_failed') {
							milestones_failed = parser.getIntegerValue();
						} else if (text == 'touchstone_pts_earned') {
							touchstone_pts_earned = parser.getIntegerValue();
						} else if (text == 'touchstone_pts_still_available') {
							touchstone_pts_still_available = parser.getIntegerValue();
						} else if (text == 'touchstone_failed') {
							touchstone_failed = parser.getIntegerValue();
						} else if (text == 'final_mls_pts_earned') {
							final_mls_pts_earned = parser.getIntegerValue();
						} else if (text == 'avg_milestones_score') {
							avg_milestones_score = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Overview consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Student student {get;set;} 
		public List<Courses> courses {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'student') {
							student = new Student(parser);
						} else if (text == 'courses') {
							courses = arrayOfCourses(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Student {
		public Integer id {get;set;} 
		public String external_id {get;set;} 
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public String email {get;set;} 

		public Student(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'external_id') {
							external_id = parser.getText();
						} else if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Student consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Units {
		public String name {get;set;} 
		public List<Items> items {get;set;} 

		public Units(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'items') {
							items = arrayOfItems(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Units consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static SophiaJSONHandler parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SophiaJSONHandler(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<Courses> arrayOfCourses(System.JSONParser p) {
        List<Courses> res = new List<Courses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Courses(p));
        }
        return res;
    }

    private static List<Items> arrayOfItems(System.JSONParser p) {
        List<Items> res = new List<Items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Items(p));
        }
        return res;
    }

    private static List<Units> arrayOfUnits(System.JSONParser p) {
        List<Units> res = new List<Units>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Units(p));
        }
        return res;
    }
}