import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superhero_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      backgroundColor: SuperheroColors.background,
      body: SafeArea(
        child: MainPageContent(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {

  const MainPageContent({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _MainPageState state = context.findAncestorStateOfType<_MainPageState>()!;
    final MainBloc bloc = state.bloc;
    return Stack(
      children: [
        const MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              bloc.nextState();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 38),
              child: Text(
                'Next State'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 14,
                    color: SuperheroColors.whiteText,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {

  const MainPageStateWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _MainPageState state = context.findAncestorStateOfType<_MainPageState>()!;
    final MainBloc bloc = state.bloc;
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return const LoadingIndicator();
          case MainPageState.noFavorites:
          case MainPageState.minSymbols:
          case MainPageState.nothingFound:
          case MainPageState.loadingError:
          case MainPageState.searchResults:
          case MainPageState.favorites:
          default:
            return Center(
              child: Text(
                state.toString(),
                style: const TextStyle(
                    fontSize: 20,
                    color: SuperheroColors.whiteText,
                    fontWeight: FontWeight.w600),
              ),
            );
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperheroColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
