import 'package:PolyHxApp/redux/reducers/activities-schedule-reducer.dart';
import 'package:PolyHxApp/redux/reducers/activity-description-reducer.dart';
import 'package:PolyHxApp/redux/reducers/activity-reducer.dart';
import 'package:PolyHxApp/redux/reducers/attendee-retrieval-reducer.dart';
import 'package:PolyHxApp/redux/reducers/current-attendee-reducer.dart';
import 'package:PolyHxApp/redux/reducers/current-user-reducer.dart';
import 'package:PolyHxApp/redux/reducers/notification-reducer.dart';
import 'package:PolyHxApp/redux/reducers/profile-reducer.dart';
import 'package:PolyHxApp/redux/reducers/sponsors-reducer.dart';
import 'package:PolyHxApp/redux/state.dart';
import 'package:PolyHxApp/redux/reducers/event-reducer.dart';
import 'package:PolyHxApp/redux/reducers/current-event-reducer.dart';
import 'package:PolyHxApp/redux/reducers/login-reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    eventState: eventReducer(state.eventState, action),
    loginState: loginReducer(state.loginState, action),
    profileState: profileReducer(state.profileState, action),
    currentUser: currentUserReducer(state.currentUser, action),
    sponsorsState: sponsorsReducer(state.sponsorsState, action),
    activityState: activityReducer(state.activityState, action),
    currentEvent: currentEventReducer(state.currentEvent, action),
    currentAttendee: currentAttendeeReducer(state.currentAttendee, action),
    notificationState: notificationReducer(state.notificationState, action),
    attendeeRetrievalState: attendeeRetrievalReducer(state.attendeeRetrievalState, action),
    activitiesScheduleState: activitiesScheduleReducer(state.activitiesScheduleState, action),
    activityDescriptionState: activityDescriptionReducer(state.activityDescriptionState, action)
  );
}

