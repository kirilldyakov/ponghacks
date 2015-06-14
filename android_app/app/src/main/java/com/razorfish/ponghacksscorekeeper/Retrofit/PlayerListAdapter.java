package com.razorfish.ponghacksscorekeeper.Retrofit;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.razorfish.ponghacksscorekeeper.R;
import com.razorfish.ponghacksscorekeeper.Retrofit.Models.Player;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by timothy.lau on 2015-06-07.
 */
public class PlayerListAdapter extends ArrayAdapter {
    private ImageView playerAvatar;
    private TextView playerName;

    private List list = new ArrayList();

    public PlayerListAdapter(Context context) {
        super(context, 0);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Player player = (Player) getItem(position);

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.player_list_row, parent, false);
        }

        playerAvatar = (ImageView) convertView.findViewById(R.id.playerAvatar);
        playerName = (TextView) convertView.findViewById(R.id.playerName);

        Picasso.with(getContext()).load(player.getAvatarUrl()).into(playerAvatar);

        playerName.setText(player.getName());

        return convertView;
    }
}
