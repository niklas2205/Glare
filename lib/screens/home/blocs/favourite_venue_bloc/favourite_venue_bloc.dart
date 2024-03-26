import 'package:bloc/bloc.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';

part 'favourite_venue_event.dart';
part 'favourite_venue_state.dart';

class FavouriteVenueBloc extends Bloc<FavouriteVenueEvent, FavouriteVenueState> {
  final DatabaseRepository databaseRepository;

  FavouriteVenueBloc(this.databaseRepository) : super(FavoritesLoading()) {
    on<AddVenueToFavorites>(_onAddVenueToFavorites);
    on<RemoveVenueFromFavorites>(_onRemoveVenueFromFavorites);
    on<LoadUserFavorites>(_onLoadUserFavorites);
  }

  void _onAddVenueToFavorites(AddVenueToFavorites event, Emitter<FavouriteVenueState> emit) async {
    try {
      await databaseRepository.addToFavorites(event.userId, event.venueId);
      emit(FavoriteAdded());
    } catch (_) {
      emit(FavoriteActionError());
    }
  }

  Future<void> _onRemoveVenueFromFavorites(RemoveVenueFromFavorites event, Emitter<FavouriteVenueState> emit) async {
    try {
      await databaseRepository.removeFromFavorites(event.venueId, event.userId);
      emit(FavoriteRemoved());
    } catch (_) {
      emit(FavoriteActionError());
    }
  }

  void _onLoadUserFavorites(LoadUserFavorites event, Emitter<FavouriteVenueState> emit) async {
    try {
      List<String> favorites = await databaseRepository.fetchUserFavorites(event.userId);
      emit(FavoritesLoaded(favorites));
    } catch (_) {
      emit(FavoritesLoadError());
    }
  }
}