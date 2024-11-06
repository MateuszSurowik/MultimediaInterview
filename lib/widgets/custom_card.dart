import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.color,
    required this.image,
    required this.title,
  });

  final Color color;
  final String image;
  final String title;

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildCardDecoration(),
      child: Stack(
        children: [
          _buildCardImage(),
          _buildFavoriteButton(),
          _buildCardTitle(),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: widget.color,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _buildCardImage() {
    if (widget.image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          widget.image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container();
  }

  Positioned _buildFavoriteButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: _toggleFavorite,
        child: _favoriteButton(),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Container _favoriteButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.green : Colors.white,
        size: 24,
      ),
    );
  }

  Positioned _buildCardTitle() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 3,
          softWrap: false,
        ),
      ),
    );
  }
}
