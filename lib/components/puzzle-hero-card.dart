import 'package:CSGamesApp/components/expansion-card.dart';
import 'package:CSGamesApp/components/pill-button.dart';
import 'package:CSGamesApp/domain/puzzle-hero.dart';
import 'package:CSGamesApp/redux/actions/puzzle-actions.dart';
import 'package:CSGamesApp/redux/state.dart';
import 'package:CSGamesApp/services/localization.service.dart';
import 'package:CSGamesApp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PuzzleHeroCard extends StatelessWidget {
    final PuzzleInfo _puzzle;

    PuzzleHeroCard(this._puzzle);

    Widget _buildRightIcon(_PuzzleHeroCardViewModel model) {
        if (_puzzle.completed) {
            return Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.green,
                size: 30.0,
            );
        } else if (_puzzle.locked) {
            return Icon(
                FontAwesomeIcons.lock,
                color: Colors.red,
                size: 30.0
            );
        } else {
            return Icon(
                FontAwesomeIcons.timesCircle,
                color: Colors.grey,
                size: 30.0
            );
        }
    }

    Widget _buildCardTitle(BuildContext context, _PuzzleHeroCardViewModel model) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Icon(
                        FontAwesomeIcons.camera,
                        size: 40.0,
                        color: Constants.polyhxGrey
                    )
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Text(
                                    _puzzle.label,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'OpenSans'
                                    )
                                )
                            ]
                        )
                    )
                ),
                Container(
                    width: 70.0,
                    height: 70.0,
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: _buildRightIcon(model)
                    )
                )
            ]
        );
    }

    List<Widget> _buildCardContent(BuildContext context, _PuzzleHeroCardViewModel model) {
        Color color;
        String text;
        Function function;
        if (_puzzle.completed) {
            color = Colors.grey;
            text = LocalizationService
                .of(context)
                .puzzle['completed'];
            function = () {};
        } else if (model.answer != '' && !model.hasValidationErrors) {
            color = Constants.csBlue;
            text = LocalizationService
                .of(context)
                .puzzle['submit'];
            function = () => model.validate(model.answer, _puzzle.id, context);
        } else {
            color = Constants.csRed;
            text = LocalizationService
                .of(context)
                .puzzle['scan'];
            function = () => model.scan(_puzzle.id, context);
        }
        return <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                child: MarkdownBody(
                    data: _puzzle.description[LocalizationService
                        .of(context)
                        .language] ?? ""
                )
            ),
            model.answer != '' ? Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                    model.answer,
                    style: TextStyle(
                        fontSize: 13.0,
                        height: 1.1,
                        fontFamily: 'OpenSans',
                        color: model.hasValidationErrors ? Colors.red : Colors.black
                    )
                )
            ) : Container(),
            Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: PillButton(
                    color: color,
                    onPressed: function,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
                        child: Text(
                            text,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                            )
                        )
                    )
                )
            )
        ];
    }

    @override
    Widget build(BuildContext context) {
        return StoreConnector<AppState, _PuzzleHeroCardViewModel>(
            onInit: (store) {
                store.dispatch(SetPuzzleAction(_puzzle));
            },
            converter: (store) => _PuzzleHeroCardViewModel.fromStore(_puzzle.id, store),
            builder: (BuildContext context, _PuzzleHeroCardViewModel model) {
                return Container(
                    margin: const EdgeInsets.fromLTRB(17.0, 5.0, 15.0, 5.0),
                    child: Stack(
                        children: <Widget>[
                            Positioned(
                                top: 10.0,
                                child: Center(
                                    child: Container(
                                        width: 20,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4.0,
                                                    offset: Offset(0, 1),
                                                    spreadRadius: 0.0
                                                )
                                            ]
                                        ),
                                        child: Material(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Constants.csBlue,
                                            child: Text('')
                                        )
                                    )
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Material(
                                    borderRadius: BorderRadius.circular(15.0),
                                    elevation: 1.0,
                                    color: Colors.white,
                                    child: Theme(
                                        data: Theme.of(context).copyWith(accentColor: Colors.black),
                                        child: !_puzzle.locked
                                            ? ExpansionCard(
                                            title: _buildCardTitle(context, model),
                                            children: _buildCardContent(context, model)
                                        )
                                            : _buildCardTitle(context, model)
                                    )
                                )
                            )
                        ]
                    )
                );
            }
        );
    }
}

class _PuzzleHeroCardViewModel {
    bool hasScanErrors;
    bool hasValidationErrors;
    String answer;
    Function scan;
    Function validate;

    _PuzzleHeroCardViewModel(this.hasScanErrors,
        this.hasValidationErrors,
        this.scan,
        this.answer,
        this.validate);

    _PuzzleHeroCardViewModel.fromStore(String puzzleId, Store<AppState> store) {
        if (store.state.puzzlesState.puzzles[puzzleId] != null) {
            hasScanErrors = store.state.puzzlesState.puzzles[puzzleId].hasScanErrors;
            hasValidationErrors = store.state.puzzlesState.puzzles[puzzleId].hasValidationErrors;
            answer = store.state.puzzlesState.puzzles[puzzleId].answer;
            scan = (puzzleId, context) => store.dispatch(ScanAction(puzzleId, context));
            validate = (answer, puzzleId, context) => store.dispatch(ValidateAction(answer, puzzleId, context));
        } else {
            hasScanErrors = false;
            hasValidationErrors = false;
            answer = '';
            scan = () {};
            validate = () {};
        }
    }
}