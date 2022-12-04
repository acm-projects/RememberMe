import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/screens/DeckView.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/cardavatar.dart';

class DeckCarousel extends StatefulWidget {
  const DeckCarousel({super.key, required this.decks, this.onChange});

  final List<Deck> decks;
  final void Function()? onChange;

  @override
  State<DeckCarousel> createState() => _DeckCarouselState();
}

class _DeckCarouselState extends State<DeckCarousel> {
  double _scrollValue = -1;
  int _lastFullScroll = -1;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        pauseAutoPlayOnManualNavigate: true,
        pauseAutoPlayOnTouch: true,
        pauseAutoPlayInFiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        autoPlayCurve: Curves.easeInOut,
        height: 200,
        aspectRatio: 2.0,
        initialPage: _currentPage,
        onScrolled: (value) {
          if (value == null) return;
          setState(() {
            _scrollValue = value;
            if (_scrollValue % 1 == 0 || _lastFullScroll == -1) {
              _lastFullScroll = value.round();
            }
          });
        },
        onPageChanged: (index, reason) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      items: _getCarouselItems(),
    );
  }

  List<Widget> _getCarouselItems() {
    double percent = sin(pi * (_scrollValue - _lastFullScroll)).abs();
    return widget.decks
        .map(
          (deck) => _CarouselItem(
            percent: percent,
            deck: deck,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeckView(initialDeck: deck),
                ),
              );
              if (widget.onChange != null) {
                widget.onChange!();
              }
            },
          ),
        )
        .toList();
  }
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({
    super.key,
    required this.percent,
    required this.deck,
    this.onTap,
  })  : invPercent = 1 - percent,
        zoomMargin = 20 * percent,
        cardElevation = 2 + 4 * percent,
        titleSize = 4 * (1 - percent) + 28;

  final Deck deck;
  final void Function()? onTap;

  static const cardCount = 5;
  final double percent, invPercent, zoomMargin, cardElevation, titleSize;

  static List<Color> stackCardColors = const [
    Color(0xFFFFA77C),
    Color(0xFFFFD15B),
    Color(0xFFFBF67C),
    Color(0xFFC3EB70),
    Color(0xFF9DE870),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: List.generate(
          cardCount,
          (i) => _getStackCard(i),
          growable: false,
        ).reversed.toList(),
      ),
    );
  }

  Widget _getStackCard(int index) {
    final normIndex = index / (cardCount - 1);
    final color = stackCardColors[index];

    Widget? body;
    if (index == 0) {
      body = Center(
        child: Text(
          deck.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (deck.cards.length >= index) {
      body = Padding(
        padding: const EdgeInsets.all(8),
        child: CardAvatar(
          card: deck.cards[index - 1],
        ),
      );
    }

    return Align(
      alignment: FractionalOffset(
        0.5 + (normIndex - 0.5) * 0.9 * (1 - percent.abs()),
        normIndex,
      ),
      child: Card(
        margin: EdgeInsets.all(zoomMargin),
        color: color,
        elevation: cardElevation,
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.9,
          child: body,
        ),
      ),
    );
  }
}
