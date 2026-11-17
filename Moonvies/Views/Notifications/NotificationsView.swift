import SwiftUI

/// Pantalla Notificaciones: películas que llevan mucho tiempo en "Por ver"
/// Tocar un recordatorio abre el detalle de la película
struct NotificationsView: View {
    @State private var viewModel: NotificationsViewModel

    @Environment(\.dismiss) private var dismiss

    init(viewModel: NotificationsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            NotificationsHeaderView {
                dismiss()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, AppTheme().screenPadding)

                    if viewModel.reminders.isEmpty {
                        MessageView(title: "No tienes películas pendientes por ahora")
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.reminders) { reminder in
                                ReminderRowView(reminder: reminder)
                            }
                        }
                        .padding(.horizontal, AppTheme().screenPadding)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

/// Header de Notificaciones: botón de regresar + título
struct NotificationsHeaderView: View {
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            BackButton(action: onBack)

            Text("Notificaciones")
                .font(.title3)
                .bold()
                .foregroundStyle(.black)
                .accessibilityAddTraits(.isHeader)

            Spacer()
        }
        .headerStyle()
    }
}

/// Un recordatorio: póster pequeño + "Hace 2 semanas tienes pendiente por ver ..."
struct ReminderRowView: View {
    let reminder: WatchlistReminder

    var body: some View {
        NavigationLink(value: Route.detail(reminder.movie)) {
            HStack(spacing: 14) {
                PosterView(movie: reminder.movie, width: 60, height: 90, showsTitle: false)

                VStack(alignment: .leading, spacing: 6) {
                    Text(reminder.message)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    Text("Toca para ver el detalle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(AppTheme().accent.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme().cornerRadius))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(reminder.message)
        .accessibilityHint("Toca dos veces para ver el detalle")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    NavigationStack {
        ReminderRowView(reminder: WatchlistReminder(movie: .sample, daysPending: 14))
            .padding()
    }
}
